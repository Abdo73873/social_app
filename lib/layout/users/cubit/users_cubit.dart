
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/users/cubit/users_states.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/users/requests.dart';
import 'package:social_app/modules/users/all_users_screen.dart';
import 'package:social_app/modules/users/friends_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/network/remote/sen_notify.dart';

class UsersCubit extends Cubit<UsersStates> {
  UsersCubit() : super(UsersInitializeState());

  static UsersCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> usersScreens = [
    AllUsersScreen(),
    FiendsScreen(),
    RequestsScreen(),
  ];

  void changeUsersBottomScreen(int index) {
        currentIndex = index;
        emit(UsersChangeBottomState());
  }

  bool isDark = false;

  void changeMode({
    bool? fromCache,
  }) {
    if (fromCache != null) {
      isDark = fromCache;
      emit(UsersChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(UsersChangeModeState());
      });
    }
  }

  List<UserModel> users = [];

  void streamGetUsersData() {
    users = [];
    emit(UsersLoadingGetUsersState());
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
    .listen((event) {
      users = [];
      for (var docUser in event.docs) {
        users.add(UserModel.fromJson(docUser.data()));
      }
      emit(UsersSuccessGetUsersState());
    });

  }


  List<String> friendsIds=[];
  void streamFriends() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .collection('friends')
        .snapshots().listen((event) {
      friendsIds = [];
      for (var docFriend in event.docs) {
        friendsIds.add(docFriend.id);
      }
      emit(UsersStreamFriendState());
    });
  }

  List<String> requestsUid=[];
  void streamRequests() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .collection('requests')
        .snapshots().listen((event) {
      requestsUid = [];
      for (var docRequest in event.docs) {
        requestsUid.add(docRequest.id);
      }
      emit(UsersStreamRequestsState());
    });
  }

  List<UserModel> friendsWhenSearch = [];
  void usersSearch(String text) {
      //private code here


    emit(UsersFriendsSearchState());

  }


  bool foundFriend = false;

  void friendsSearch(String text) {
      //private code here

    emit(UsersFriendsSearchState());

  }


  void sendRequest(String userId,String? token){
   //private code here

  }

  void removeRequest(String friendId){
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('requests')
        .doc(myId).delete();
    emit(UsersRemoveRequestState());
  }

  void acceptFriend(String friendId,String? token){
      //private code here

  }

  void deleteRequest(String friendId){
    FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .collection('requests')
        .doc(friendId).delete();
    emit(UsersRemoveRequestState());
  }

  void deleteFriend(String friendId){
    //private code here


    emit(UsersRemoveRequestState());



  }




}
