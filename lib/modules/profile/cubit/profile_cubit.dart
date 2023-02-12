import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/modules/profile/cubit/profile_states.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitializeState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  List<bool> readOnly = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ];

  void changeOpenEdit(int index) {
    readOnly[index] = !readOnly[index];
    emit(ProfileOpenEditState());
  }

  void changeToAdd() {
    openToAdd = !openToAdd;
    emit(ProfileOpenEditState());
  }

  File? profileImage;
  File? coverImage;
  final picker = ImagePicker();

  Future getImage(imageName, isGallery) async {
    ImageSource source;
    if (isGallery) {
      source = ImageSource.gallery;
    } else {
      source = ImageSource.camera;
    }
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      if (imageName == "profile") {
        profileImage = File(pickedFile.path);
        isUploadCompleted=false;
        emit(ProfileGetImageProfileSuccessState());
        uploadImage(profileImage,"profile");

      }
      if (imageName == "cover") {
        coverImage = File(pickedFile.path);
        isUploadCompleted=false;
        emit(ProfileGetImageCoverSuccessState());
        uploadImage(coverImage,"cover");

      }
    } else {
      print('no image selected');
      emit(ProfileGetImageErrorState());
    }
  }


  bool? isUploadCompleted;
  void uploadImage(File? image,String name) {
    isUploadCompleted=false;
    emit(ProfileUploadImageProfileLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(image!.path)
        .pathSegments
        .last}')
        .putFile(image!)
        .then((value) {
      value.ref.getDownloadURL().whenComplete((){
        isUploadCompleted=true;
        emit(ProfileUploadCompletedState());
      }).then((value) {
        if(name=="profile"){
          myModel.image=value;
          emit(ProfileUploadImageProfileSuccessState());
        }
         if(name=="cover"){
          myModel.cover = value;
          emit(ProfileUploadImageCoverSuccessState());
        }
      }).catchError((error) {
        emit(ProfileUploadErrorState());
      });
    }).catchError((error) {
      emit(ProfileUploadErrorState());
    });
  }


  void updateUser() {

FirebaseFirestore.instance
    .collection('users')
    .doc(myId)
    .update(myModel.toMaP())
    .then((value) {
        emit(ProfileUpdateSuccessState());
})
    .catchError((error) {
  emit(ProfileUpdateErrorState());

});
}


}
