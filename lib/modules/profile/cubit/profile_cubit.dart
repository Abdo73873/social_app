import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  Future getImage(String imageName, bool isGallery) async {
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
        emit(ProfileGetImageProfileSuccessState());
      }
      if (imageName == "cover") {
        coverImage = File(pickedFile.path);
        emit(ProfileGetImageCoverSuccessState());
      }
    } else {
      print('no image selected');
      emit(ProfileGetImageErrorState());
    }
  }

  String profileImageUrl = '';

  void uploadProfileImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        emit(ProfileUploadImageProfileSuccessState());
      }).catchError((error) {
        emit(ProfileUploadErrorState());
      });
    }).catchError((error) {
      emit(ProfileUploadErrorState());
    });
  }

  String coverImageUrl = '';

  void uploadCoverImage() {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        emit(ProfileUploadImageCoverSuccessState());
      }).catchError((error) {
        emit(ProfileUploadErrorState());
      });
    }).catchError((error) {
      emit(ProfileUploadErrorState());
    });
  }

  /*void updateUser() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update()
        .then((value) {})
        .catchError((error) {});
  }
  */
}
