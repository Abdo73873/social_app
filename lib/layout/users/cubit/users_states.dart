

abstract class UsersStates {}

class UsersInitializeState extends UsersStates {}

class UsersChangeBottomState extends UsersStates {}

class UsersChangeModeState extends UsersStates{}


class UsersLoadingGetUsersState extends UsersStates {}
class UsersSuccessGetUsersState extends UsersStates {}
class UsersErrorGetUsersState extends UsersStates {
  final String error;
  UsersErrorGetUsersState(this.error);
}

class UsersFriendsSearchState extends UsersStates {}

class UsersAddFriendState extends UsersStates {}
class UsersRemoveRequestState extends UsersStates {}


class UsersLoadingUserState extends UsersStates {}
class UsersSuccessUserState extends UsersStates {}
class UsersErrorUserState extends UsersStates {
  final String error;
  UsersErrorUserState(this.error);
}