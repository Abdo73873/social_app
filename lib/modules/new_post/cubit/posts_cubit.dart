import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/modules/new_post/cubit/posts_states.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/shared/network/remote/dio_helper.dart';
import 'package:social_app/shared/network/remote/sen_notify.dart';

class PostsCubit extends Cubit<PostsStates> {
  PostsCubit() : super(PostsInitializeState());

  static PostsCubit get(context) => BlocProvider.of(context);

  File? postImage;
  final picker = ImagePicker();

  Future getImage(isGallery) async {

    ImageSource source;
    if (isGallery) {
      source = ImageSource.gallery;
    } else {
      source = ImageSource.camera;
    }

    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
        postImage = File(pickedFile.path);
        emit(PostsGetImagePostsSuccessState());
    } else {
      print('no image selected');
      emit(PostsGetImageErrorState());
    }
  }

  void removeImage(){
    postImage=null;
    emit(PostsRemoveImageState());
  }

  String postImageUrl = '';
  void uploadImage({
    String? text,
    bool isEdit=false,
    PostsModel? post,

  }) {
    emit(PostsLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri
        .file(postImage!.path)
        .pathSegments
        .last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        postImageUrl = value;
        postImage=null;
        if(!isEdit){
          createPost(text: text);
        }
        else{
          editPost(post: post!,text: text);
        }
        emit(PostsUploadImageSuccessState());
      }).catchError((error) {
        emit(PostsUploadErrorState());
      });
    }).catchError((error) {
      emit(PostsUploadErrorState());
    });
  }



  void createPost({
    String? text,

}) {
emit(PostsLoadingState());

    PostsModel model=PostsModel
      (
        uId: myModel.uId,
      dateTime: DateFormat.yMd().add_jm().format(DateTime.now()).toString(),
      text: text,
      postImage: postImageUrl,
      postId: '',
    );
    postImageUrl='';
    FirebaseFirestore.instance
       .collection('posts')
        .add(model.toMaP())
        .then((docRef)  {
          model.postId=docRef.id;
      FirebaseFirestore.instance
          .collection('posts')
          .doc(docRef.id)
          .update(model.toMaP());
        sendNotify(
            to:'/topics/notification',
            title: 'Published a new Post',
            message:model.text!=null?'${model.text?.substring(0,text!.length>10?10:text.length)}':'photo',
            userId: myId!,
         name: myModel.name,
         image: myModel.image,
        );
      emit(PostsCreateSuccessState());
    })
        .catchError((error) {
      emit(PostsCreateErrorState());

    });
  }

  void editPost({
    required PostsModel post,
    String? text,
  }){
    post.text=text;
    if(postImageUrl.isNotEmpty){
      post.postImage=postImageUrl;
    }
    postImageUrl='';
    FirebaseFirestore.instance
        .collection('posts')
        .doc(post.postId)
        .update(post.toMaP());
  }


}
