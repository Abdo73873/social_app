
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
      friendsWhenSearch = [];
        for (int i = 0; i < users.length; i++) {
          if (users[i].uId!=myId) {
            if (users[i].email.toLowerCase().contains(text.toLowerCase())) {
              friendsWhenSearch.add(users[i]);
              emit(UsersFriendsSearchState());
            }
            else if (users[i].name.toLowerCase().contains(text.toLowerCase())) {
              friendsWhenSearch.add(users[i]);
              emit(UsersFriendsSearchState());
            }
          }
          else {
            emit(UsersFriendsSearchState());
          }
        }

    emit(UsersFriendsSearchState());

  }


  bool foundFriend = false;

  void friendsSearch(String text) {
    friendsWhenSearch = [];
    for (int i=0;i<friendsIds.length;i++) {
         for(int y=i;y<users.length;y++){
           if(friendsIds[i]==users[y].uId){
             if(users[y].name.toLowerCase().contains(text.toLowerCase())){
               friendsWhenSearch.add(users[y]);
             }
           }
         }
        }
    emit(UsersFriendsSearchState());

  }


  void sendRequest(String userId,String? token){
    print('===========token$token==========\n');
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('requests')
        .doc(myId).set({});
      emit(UsersAddFriendState());
      if(token!=null) {
        print('===========token==========\n');
        sendNotify(to: token,
            title: 'Send you a request',
            message:'accept ${myModel.male?'him':'her'} to be friends or delete from Requests',
            userId: myModel.uId,
            name: myModel.name,
            image: myModel.image,
        );
      }
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
    if(token!=null) {
      sendNotify(to: token,
          title: 'Accepted your request',
          message: 'you can chat now',
          userId: myModel.uId,
          name: myModel.name,
          image: myModel.image,
      );
    }
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
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(myId).delete();

    emit(UsersRemoveRequestState());



  }




}
