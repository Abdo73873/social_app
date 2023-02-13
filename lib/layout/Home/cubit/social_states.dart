

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

class HomeChatSearchState extends HomeStates {}
class HomeChatTypingState extends HomeStates {}

class HomeSendMessageSuccessState extends HomeStates {}
class HomeSendMessageErrorState extends HomeStates {}

class HomeReceiveMessageSuccessState extends HomeStates {}
class HomeReceiveMessageErrorState extends HomeStates {}

class HomeStreamFriendState extends HomeStates {}

class HomeLoadingGetFriendState extends HomeStates {}
class HomeSuccessGetFriendState extends HomeStates {}


class HomeChatGetImageSuccessState extends HomeStates {}
class HomeChatGetImageErrorState extends HomeStates {}

class HomeChatUploadImageLoadingState extends HomeStates {}
class HomeChatUploadImageSuccessState extends HomeStates {}
class HomeChatUploadImageErrorState extends HomeStates {}

class HomeChatRemoveImageState extends HomeStates {}



class HomeChangeLanguageState extends HomeStates {}
class HomeLoadingHomeState extends HomeStates {}
class HomeSuccessHomeState extends HomeStates {}
class HomeErrorHomeState extends HomeStates {
  final String error;
  HomeErrorHomeState(this.error);
}