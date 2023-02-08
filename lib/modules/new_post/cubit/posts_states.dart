

abstract class PostsStates {}

class PostsInitializeState extends PostsStates {}

class PostsRemoveImageState extends PostsStates {}
class PostsLoadingState extends PostsStates {}

class PostsGetImagePostsSuccessState extends PostsStates {}
class PostsGetImageErrorState extends PostsStates {}

class PostsUploadImageSuccessState extends PostsStates {}
class PostsUploadErrorState extends PostsStates {}

class PostsCreateSuccessState extends PostsStates {}
class PostsCreateErrorState extends PostsStates {}



class PostsLoadingGetUserState extends PostsStates {}

class PostsSuccessGetUserState extends PostsStates {}

class PostsErrorGetUserState extends PostsStates {
  final String error;
  PostsErrorGetUserState(this.error);
}




class PostsSuccessState extends PostsStates {}

class PostsErrorState extends PostsStates {
  final String error;
  PostsErrorState(this.error);
}