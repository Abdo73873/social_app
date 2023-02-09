

abstract class HomeStates {}

class HomeInitializeState extends HomeStates {}

class HomeChangeBottomState extends HomeStates {}

class HomeChangeModeState extends HomeStates{}

class HomeLoadingGetUserState extends HomeStates {}
class HomeSuccessGetUserState extends HomeStates {}
class HomeErrorGetUserState extends HomeStates {
  final String error;
  HomeErrorGetUserState(this.error);
}

class HomeNewPostState extends HomeStates {}
class HomeLoadingGetPostsState extends HomeStates {}
class HomeSuccessGetPostsState extends HomeStates {}
class HomeErrorGetPostsState extends HomeStates {
  final String error;
  HomeErrorGetPostsState(this.error);
}


class HomeLoadingGetUsersState extends HomeStates {}
class HomeSuccessGetUsersState extends HomeStates {}
class HomeErrorGetUsersState extends HomeStates {
  final String error;
  HomeErrorGetUsersState(this.error);
}

class HomeSuccessLikeState extends HomeStates {}
class HomeErrorLikeState extends HomeStates {
  final String error;
  HomeErrorLikeState(this.error);
}
class HomeSuccessUnLikeState extends HomeStates {}
class HomeErrorUnLikeState extends HomeStates {
  final String error;
  HomeErrorUnLikeState(this.error);
}
class HomeCounterLikesState extends HomeStates {}



class HomeChangeLanguageState extends HomeStates {}
class HomeLoadingHomeState extends HomeStates {}
class HomeSuccessHomeState extends HomeStates {}
class HomeErrorHomeState extends HomeStates {
  final String error;
  HomeErrorHomeState(this.error);
}