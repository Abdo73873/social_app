import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitializeState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    UsersScreen(),
    ProfileScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'Users',
    'Profile',
  ];

  int perIndex = 0;

  void changeBottomScreen(int index) {
    if (index < 2) {
      {
        currentIndex = index;
        emit(HomeChangeBottomState());
      }
    } else if (index == 2) {
      if (currentIndex < 2) {
        perIndex = currentIndex;
        currentIndex = 2;
      } else if (currentIndex >= 2) {
        perIndex = currentIndex + 1;
        currentIndex = 0;
      }

      emit(HomeNewPostState());
    } else if (index > 2) {
      {
        currentIndex = index - 1;
        emit(HomeChangeBottomState());
      }
    }
  }

  bool isDark = false;

  void changeMode({
    bool? fromCache,
  }) {
    if (fromCache != null) {
      isDark = fromCache;
      emit(HomeChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(HomeChangeModeState());
      });
    }
  }

  void getUserData() {
    emit(HomeLoadingGetUserState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(HomeSuccessGetUserState());
    }).catchError((error) {
      emit(HomeErrorGetUserState(error.toString()));
    });
  }

/*
  List<PostsModel> posts = [];
  int likes =0;
  int index=0;

  void getPosts() {
    emit(HomeLoadingGetPostsState());
    FirebaseFirestore.instance.collection('posts')
    .snapshots().listen((event) {
      posts = [];
       index=0;
      likes =0;
      for (var docPost in event.docs) {
        print("----------------------\n");
        posts.add(PostsModel.fromJson(docPost.data()));
        docPost.reference
            .collection('likes')
            .get()
            .then((value) {
              for (var element in value.docs) {
                print("==================\n");
                likes++;
                emit(HomeCounterLikesState());
              }
        }).catchError((error){
          emit(HomeErrorLikeState(error.toString()));
        });

      }
      emit(HomeSuccessGetPostsState());
    });
  }

*/

/*

  void getLikes(String postId){

    emit(HomeLoadingGetPostsState());
    for(var element in posts){
      if(element.postId==postId){
    FirebaseFirestore.instance.
    collection('posts')
        .doc(postId)
        .collection('likes')
    .snapshots().listen((event) {
      index = 0;
      likes = 0;
      for (var docLikes in event.docs) {
        print("----------------------\n");

        element.usersLiked;
      }
    }

        }


      }
      emit(HomeSuccessGetPostsState());

  }

*/

  List<UserModel> users = [];

  void getUsersData() {
    users = [];
    emit(HomeLoadingGetUsersState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      for (var element in value.docs) {
        users.add(UserModel.fromJson(element.data()));
        print(element.data());
        print('===============================\n');
      }
      emit(HomeSuccessGetUsersState());
    }).catchError((error) {
      emit(HomeErrorGetUsersState(error.toString()));
    });
  }

  bool like = false;

  void likePost(String postId) {
    like = !like;
    if (like) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId)
          .set({
        'like': true,
      }).then((value) {
        emit(HomeSuccessLikeState());
      }).catchError((error) {
        emit(HomeErrorLikeState(error.toString()));
      });
    } else {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId)
          .delete();
      emit(HomeSuccessUnLikeState());
    }
  }

  void addComment(String postId, List<Map<String, String>> comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userId)
        .update({
          'comments': FieldValue.arrayUnion([comment]),
        })
        .then((value) {})
        .catchError((error) {});
  }

  void updateComment(String postId, String comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userId)
        .update({
          'comments': FieldValue.arrayRemove([comment]),
        })
        .then((value) {})
        .catchError((error) {});
  }

  void removeComment(String postId, String comment) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userId)
        .update({
          'comments': FieldValue.delete,
        })
        .then((value) {})
        .catchError((error) {});
  }

  List<UserModel> friendsWhenSearch = [];
  bool found = false;

  void chatSearch(String text) {
    String word = '';
    if (text.isEmpty) {
      found = false;
      emit(HomeChatSearchState());
    } else {
      friendsWhenSearch = [];
      for (int iText = 0; iText < text.length; iText++) {
        word += text[iText];
      }
      for (int index = 0; index < users.length; index++) {
        if(users[index].uId!=userId){
          if (word.toLowerCase() ==
              users[index].name
                  .substring(0,
                  word.length <= users[index].name.length
                      ? word.length
                      : users[index].name.length)
                  .toLowerCase()) {
            found = true;
            friendsWhenSearch.add(users[index]);
            emit(HomeChatSearchState());
          }
        }
        else{found=false;
        emit(HomeChatSearchState());

        }
      }
    }
  }
}
