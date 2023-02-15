

abstract class ProfileStates {}

class ProfileInitializeState extends ProfileStates {}

class ProfileOpenEditState extends ProfileStates {}

class ProfileGetImageProfileSuccessState extends ProfileStates {}
class ProfileGetImageCoverSuccessState extends ProfileStates {}
class ProfileGetImageErrorState extends ProfileStates {}

class ProfileUploadImageProfileLoadingState extends ProfileStates {}
class ProfileUploadImageProfileSuccessState extends ProfileStates {}
class ProfileUploadImageCoverSuccessState extends ProfileStates {}
class ProfileUploadCompletedState extends ProfileStates {}
class ProfileUploadErrorState extends ProfileStates {}

class ProfileUpdateSuccessState extends ProfileStates {}
class ProfileUpdateErrorState extends ProfileStates {}

class ProfileSuccessGetPostsState extends ProfileStates {}



class ProfileLoadingGetUserState extends ProfileStates {}

class ProfileSuccessGetUserState extends ProfileStates {}

class ProfileErrorGetUserState extends ProfileStates {
  final String error;
  ProfileErrorGetUserState(this.error);
}



class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {}

class ProfileErrorState extends ProfileStates {
  final String error;
  ProfileErrorState(this.error);
}

