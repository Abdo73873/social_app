

abstract class HomeStates {}

class HomeInitializeState extends HomeStates {}

class HomeLoadingGetUserState extends HomeStates {}

class HomeSuccessGetUserState extends HomeStates {}

class HomeErrorGetUserState extends HomeStates {
  final String error;
  HomeErrorGetUserState(this.error);
}

class HomeChangeBottomState extends HomeStates {}


class HomeChangeLanguageState extends HomeStates {}

class HomeLoadingHomeState extends HomeStates {}

class HomeSuccessHomeState extends HomeStates {}

class HomeErrorHomeState extends HomeStates {
  final String error;
  HomeErrorHomeState(this.error);
}