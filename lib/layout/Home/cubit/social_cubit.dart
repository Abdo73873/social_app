import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/layout/users/user_layout.dart';
import 'package:social_app/models/message_model.dart';
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
    UserLayout(),
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

  bool isDark = false;

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

  void getMyData() {
    emit(HomeLoadingGetUserState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .get()
        .then((value) {
      myModel = UserModel.fromJson(value.data()!);
      emit(HomeSuccessGetUserState());
    }).catchError((error) {
      emit(HomeErrorGetUserState(error.toString()));
    });
  }


  bool like = false;

  void likePost(String postId) {
    like = !like;
    if (like) {
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

  void addComment(String postId, List<Map<String, String>> comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(myId)
        .update({
          'comments': FieldValue.arrayUnion([comment]),
        })
        .then((value) {})
        .catchError((error) {});
  }

  void updateComment(String postId, String comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(myId)
        .update({
          'comments': FieldValue.arrayRemove([comment]),
        })
        .then((value) {})
        .catchError((error) {});
  }

  void removeComment(String postId, String comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(myId)
        .update({
          'comments': FieldValue.delete,
        })
        .then((value) {})
        .catchError((error) {});
  }




  void typing(){
    emit(HomeChatTypingState());
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
      indexMessage:messages.isNotEmpty?(messages[messages.length-1].indexMessage+1):0,
      image: image,

    );
    //ser my chars
FirebaseFirestore.instance
    .collection('users')
    .doc(myId)
    .collection('friends')
    .doc(receiverId)
    .collection('chat')
    .add(message.toMap()).then((value) {
      chatImage=null;
    emit(HomeSendMessageSuccessState());
}).catchError((error){
  emit(HomeSendMessageErrorState());
});
    //ser receiver chars

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('friends')
        .doc(myId)
        .collection('chat')
        .add(message.toMap()).then((value) {
      emit(HomeSendMessageSuccessState());
    }).catchError((error){
      emit(HomeSendMessageErrorState());
    });



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

  Future getImage(isGallery) async {
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

  bool isUploadCompleted=true;
  void uploadImage({
    required String receiverId,
    String? text,
}) {
    isUploadCompleted=false;
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
        isUploadCompleted=true;
        emit(HomeChatUploadImageSuccessState());
      }).catchError((error) {
        emit(HomeChatUploadImageErrorState());
      });
    }).catchError((error) {
      emit(HomeChatUploadImageErrorState());
    });
  }

  void removeImage(){
    chatImage=null;
    emit(HomeChatRemoveImageState());
  }


}
