import 'dart:async';

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

class UsersCubit extends Cubit<UsersStates> {
  UsersCubit() : super(UsersInitializeState());

  static UsersCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> usersScreens = [
    AllUsersScreen(),
    FiendsScreen(),
    RequestsScreen(),
  ];

  void changeBottomScreen(int index) {
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

  void getUsersData() {
    users = [];
    emit(UsersLoadingGetUsersState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        users.add(UserModel.fromJson(element.data()));
      }
      emit(UsersSuccessGetUsersState());
    }).catchError((error) {
      emit(UsersErrorGetUsersState(error.toString()));
    });
  }




StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> getUserData(String id)=>
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .snapshots()
        .listen((event) {

});


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


  List<UserModel> friendsWhenSearch = [];
  bool foundUser = false;
  void usersSearch(String text) {
    String word = '';
    if (text.isEmpty) {
      foundUser = false;
      emit(UsersFriendsSearchState());
    }
    else {
      friendsWhenSearch = [];
      for (int iText = 0; iText < text.length; iText++) {
        word += text[iText];
      }
      if(word.length>=4) {
        if (word.substring(word.length - 4) == ".com") {
          for (int index = 0; index < users.length; index++) {
            if (users[index].uId != myId) {
              if (word.toLowerCase() ==
                  users[index].email
                      .substring(0,
                      word.length <= users[index].email.length
                          ? word.length
                          : users[index].email.length)
                      .toLowerCase()) {
                foundUser = true;
                friendsWhenSearch.add(users[index]);
                emit(UsersFriendsSearchState());
              }
            }
            else {
              foundUser = false;
              emit(UsersFriendsSearchState());
            }
          }
        }
      }
      else {
        for (int index = 0; index < users.length; index++) {
          if (users[index].uId != myId) {
            if (word.toLowerCase() ==
                users[index].name
                    .substring(0,
                    word.length <= users[index].name.length
                        ? word.length
                        : users[index].name.length)
                    .toLowerCase()) {
              foundUser = true;
              friendsWhenSearch.add(users[index]);
              emit(UsersFriendsSearchState());
            }
          }
          else {
            foundUser = false;
            emit(UsersFriendsSearchState());
          }
        }
      }

    }
  }


  bool foundFriend = false;

  void friendsSearch(String text) {
    String word = '';
    if (text.isEmpty) {
      foundFriend = false;
      emit(UsersFriendsSearchState());
    }
    else {
      friendsWhenSearch = [];
      for (int iText = 0; iText < text.length; iText++) {
        word += text[iText];
      }
      FirebaseFirestore.instance
      .collection('users')
      .doc(myId)
      .collection('friends')
      .snapshots().listen((event) {
        for (var docFriend in event.docs) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(docFriend.id)
              .get().then((value){
                if(word.toLowerCase()==value.data()!['name']
                    .toString()
                    .substring(0,word.length<=value.data()!['name']
                    .toString().length?word.length:value.data()!['name']
                    .toString().length)
                    .toLowerCase()){
                  friendsWhenSearch.add(UserModel.fromJson(value.data()!));
                  foundFriend = true;
                  emit(UsersFriendsSearchState());
                }else{
                  foundFriend = false;
                  emit(UsersFriendsSearchState());
                }
          });

        }
      });


    }
  }


  void sendRequest(String friendId){
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('requests')
        .doc(myId).set({});
      emit(UsersAddFriendState());
  }
  void removeRequest(String friendId){
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('requests')
        .doc(myId).delete();
    emit(UsersRemoveRequestState());
  }

  void acceptFriend(String friendId){
    FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .collection('friends')
        .doc(friendId).set({});
    deleteRequest(friendId);
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(myId).set({});
    emit(UsersAddFriendState());

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
    FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .collection('friends')
        .doc(friendId).delete();
    emit(UsersRemoveRequestState());
  }




}
