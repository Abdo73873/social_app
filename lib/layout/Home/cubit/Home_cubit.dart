import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/Home/cubit/Home_states.dart';
import 'package:social_app/layout/users/user_layout.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitializeState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    UsersLayout(),
    ProfileScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'Users',
    'Profile',
  ];

  void changeBottomScreen(int index) {
    if (index < 2) {
      {
        currentIndex = index;
        emit(HomeChangeBottomState());
      }
    } else if (index == 2) {
      emit(HomeNewPostState());
    } else if (index > 2) {
      {
        currentIndex = index - 1;
        emit(HomeChangeBottomState());
      }
    }
  }

  bool isDark = true;

  void changeMode({
    bool? fromCache,
  }) {
    if (fromCache != null) {
      isDark = fromCache;
      emit(HomeChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(HomeChangeModeState());
      });
    }
  }


  void verifyPhone(){
    FirebaseAuth auth=FirebaseAuth.instance;
        auth.verifyPhoneNumber(
      phoneNumber: myModel.phone,
        verificationCompleted: (PhoneAuthCredential credential)async{
        await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseException e){
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
          },
        codeSent: (String verificationId,int? resendToken)async{

          // Update the UI - wait for the user to enter the SMS code
          String smsCode = 'xxxx';

          // Create a PhoneAuthCredential with the code
          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

          // Sign the user in (or link) with the credential
          await auth.signInWithCredential(credential);

        },
            timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout:(String verificationId){

        }
    );
  }


bool open=true;
  void verified() {
    if (open) {
      Future.delayed(const Duration(seconds: 60), () {
        open = false;
        emit(HomeCloseVerifyBarState());
      });
    }
  }


  void getMyData() {
    emit(HomeLoadingGetUserState());
     FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .get()
        .then((value) {
      myModel = UserModel.fromJson(value.data()!);
      emit(HomeSuccessGetUserState());
       FirebaseMessaging.instance.getToken().then((value) {
        deviceToken=value;
        myModel.deviceToken=deviceToken;
        FirebaseFirestore.instance
            .collection('users')
            .doc(myId)
            .update(myModel.toMaP());
      });

    }).catchError((error) {
      emit(HomeErrorGetUserState(error.toString()));
    });
  }

  late List<PostsModel> posts=[];

  void getPosts(int limit){
    FirebaseFirestore.instance
        .collection('posts')
    .orderBy('dateTime')
    .limitToLast(limit)
      .snapshots()
    .listen((event) {
      posts=[];
      for (var docPost in event.docs) {
        posts.add(PostsModel.fromJson(docPost.data()));
        emit(HomeSuccessGetPostsState());
      }
      emit(HomeSuccessGetPostsState());
    });

        }

  void deletePost(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .delete();
  }

  void likePost(String postId,bool liked) {
    liked = !liked;
    if (liked) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(myId)
          .set({
        'like': true,
      }).then((value) {
        emit(HomeSuccessLikeState());
      }).catchError((error) {
        emit(HomeErrorLikeState(error.toString()));
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(myId)
          .delete();
      emit(HomeSuccessUnLikeState());
    }
  }

  File? commentImage;

  Future getCommentImage(isGallery) async {
    ImageSource source;
    if (isGallery) {
      source = ImageSource.gallery;
    } else {
      source = ImageSource.camera;
    }
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      commentImage = File(pickedFile.path);
      emit(HomeCommentGetImageSuccessState());
    } else {
      print('no image selected');
      emit(HomeCommentGetImageErrorState());
    }
  }

  bool isUploadCommentImageComplete=true;
  void uploadCommentImage({
    required String postId,
     String? text,
  }) {
   isUploadCommentImageComplete=false;
    emit(HomeCommentUploadImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('comments/${Uri
        .file(commentImage!.path)
        .pathSegments
        .last}')
        .putFile(commentImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
       addComment(
         postId: postId,
       text:text ,
       image: value
       );
       commentImage=null;
       isUploadCommentImageComplete=true;
       emit(HomeCommentUploadImageSuccessState());
      }).catchError((error) {
        emit(HomeCommentUploadImageErrorState());
      });
    }).catchError((error) {
      emit(HomeCommentUploadImageErrorState());
    });
  }

  void removeCommentImage(){
    commentImage=null;
    emit(HomeCommentRemoveImageState());
  }

  void addComment({
   required String postId,
    String? text,
    String? image,

}) {
    CommentModel model=CommentModel(
        uId: myId!,
        text: text,
        image: image,
        dateTime: DateFormat.yMd().add_jms().format(DateTime.now()),
      indexComment: comments.length,

    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
          emit(HomeCommentAddSuccessState());
    })
        .catchError((error) {
      emit(HomeCommentAddErrorState());

    });
  }

  void removeComment(String postId,int index) {
   //private code here
  }

  int likesCount=0,commentCount=0;
  List<CommentModel> comments=[];
  void streamLikesAndComments(String postId,int limit){
       //private code here
   //private code here
   //private code here

  }


  void typing(){
    emit(HomeChatTypingState());
  }


  void typeComment(){
    emit(HomeCommentTypingState());
  }
    void sendMessage({
  required String receiverId,
  required String text ,
      String? image,
}){
    MessageModel message=MessageModel(
      senderId: myId!,
      text: text,
      dateTime: DateFormat.yMd().add_jms().format(DateTime.now()),
      receiverId: receiverId,
      indexMessage:messages.length,
      image: image,

    );
      //private code here
   //private code here

    }



    List<MessageModel> messages=[];
    void getMessage(String friedId,int limit){
    FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .collection('friends')
        .doc(friedId)
        .collection('chat')
        .orderBy('indexMessage')
          .limitToLast(limit)
        .snapshots()
        .listen((event) {
          messages=[];
          for (var messageId in event.docs) {
            messages.add(MessageModel.fromJson(messageId.data()));
          }

          emit(HomeReceiveMessageSuccessState());
    });

    }

  final picker = ImagePicker();
  File? chatImage;

  Future getChatImage(isGallery) async {
    ImageSource source;
    if (isGallery) {
      source = ImageSource.gallery;
    } else {
      source = ImageSource.camera;
    }
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
        chatImage = File(pickedFile.path);
        emit(HomeChatGetImageSuccessState());
    } else {
      print('no image selected');
      emit(HomeChatGetImageErrorState());
    }
  }

  bool isUploadChatImageCompleted=true;
  void uploadChatImage({
    required String receiverId,
    String? text,
}) {
    isUploadChatImageCompleted=false;
    emit(HomeChatUploadImageLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('chats/${Uri
        .file(chatImage!.path)
        .pathSegments
        .last}')
        .putFile(chatImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        sendMessage(
            receiverId: receiverId,
            text: text!,
          image: value,
        );
        chatImage=null;
        isUploadChatImageCompleted=true;
        emit(HomeChatUploadImageSuccessState());
      }).catchError((error) {
        emit(HomeChatUploadImageErrorState());
      });
    }).catchError((error) {
      emit(HomeChatUploadImageErrorState());
    });
  }

  void removeChatImage(){
    chatImage=null;
    emit(HomeChatRemoveImageState());
  }

  List<NotificationModel> notify=[];

  void streamNotification(){
    FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .collection('notification')
        .snapshots()
        .listen((event) {
      notify=[];
       for (var element in event.docs) {
         notify.add(NotificationModel.fromJson(element.data()));
       }
       emit(HomeStreamNotificationState());
    });
  }

  void clearNotification() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .collection('notification')
        .get()
        .then((value){
       for (var element in value.docs) {
         element.reference.delete();
       }
    });


  }


}
