

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

class HomeLoadingGetUsersState extends HomeStates {}
class HomeSuccessGetUsersState extends HomeStates {}

class HomeSuccessLikeState extends HomeStates {}
class HomeErrorLikeState extends HomeStates {
  final String error;
  HomeErrorLikeState(this.error);
}
class HomeSuccessUnLikeState extends HomeStates {}

class HomeChatTypingState extends HomeStates {}

class HomeSendMessageSuccessState extends HomeStates {}
class HomeSendMessageErrorState extends HomeStates {}

class HomeReceiveMessageSuccessState extends HomeStates {}

class HomeChatGetImageSuccessState extends HomeStates {}
class HomeChatGetImageErrorState extends HomeStates {}

class HomeChatUploadImageLoadingState extends HomeStates {}
class HomeChatUploadImageSuccessState extends HomeStates {}
class HomeChatUploadImageErrorState extends HomeStates {}


class HomeCommentGetImageSuccessState extends HomeStates {}
class HomeCommentGetImageErrorState extends HomeStates {}

class HomeCommentUploadImageLoadingState extends HomeStates {}
class HomeCommentUploadImageSuccessState extends HomeStates {}
class HomeCommentUploadImageErrorState extends HomeStates {}
class HomeCommentRemoveImageState extends HomeStates {}

class HomeStreamLikesAndCommentSuccessState extends HomeStates {}

class HomeChatRemoveImageState extends HomeStates {}
class HomeCommentAddSuccessState extends HomeStates {}
class HomeCommentAddErrorState extends HomeStates {}

class HomeStreamNotificationState extends HomeStates {}
