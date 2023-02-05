

abstract class ProfileStates {}

class ProfileInitializeState extends ProfileStates {}

class ProfileLoadingGetUserState extends ProfileStates {}

class ProfileSuccessGetUserState extends ProfileStates {}

class ProfileErrorGetUserState extends ProfileStates {
  final String error;
  ProfileErrorGetUserState(this.error);
}

class ProfileOpenEditState extends ProfileStates {}


class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {}

class ProfileErrorState extends ProfileStates {
  final String error;
  ProfileErrorState(this.error);
}