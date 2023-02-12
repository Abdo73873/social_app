

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


class UsersStreamFriendState extends UsersStates {}


class UsersLoadingUsersState extends UsersStates {}
class UsersSuccessUsersState extends UsersStates {}
class UsersErrorUsersState extends UsersStates {
  final String error;
  UsersErrorUsersState(this.error);
}