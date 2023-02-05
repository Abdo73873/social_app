

abstract class ProfileStates {}

class ProfileInitializeState extends ProfileStates {}

class ProfileLoadingGetUserState extends ProfileStates {}

class ProfileSuccessGetUserState extends ProfileStates {}

class ProfileErrorGetUserState extends ProfileStates {
  final String error;
  ProfileErrorGetUserState(this.error);
}


class ProfileLoadingProfileState extends ProfileStates {}

class ProfileSuccessProfileState extends ProfileStates {}

class ProfileErrorProfileState extends ProfileStates {
  final String error;
  ProfileErrorProfileState(this.error);
}