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
  HomeCubit() :super(HomeInitializeState());

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
    }
    else if (index == 2) {
      if (currentIndex < 2) {
        perIndex = currentIndex;
        currentIndex = 2;
      }
      else if (currentIndex >= 2) {
        perIndex = currentIndex + 1;
        currentIndex = 0;
      }

      emit(HomeNewPostState());
    }
    else if (index > 2) {
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
    }
    else {
      isDark = !isDark;
      CacheHelper.saveData(key: 'isDark', value: isDark).then((value) {
        emit(HomeChangeModeState());
      });
    }
  }


  void getUserData() {
    emit(HomeLoadingGetUserState());
    FirebaseFirestore.instance.collection('users').doc(userId).get().then((
        value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(HomeSuccessGetUserState());
    }).catchError((error) {
      emit(HomeErrorGetUserState(error.toString()));
    });
  }



  List<PostsModel> posts = [];
  int likes =0;
  bool like=false;
  int index=0;

  void getPosts() {
    emit(HomeLoadingGetPostsState());
    FirebaseFirestore.instance.collection('posts')
    .snapshots().listen((event) {
      posts = [];
       index=0;
      for (var docPost in event.docs) {
        posts.add(PostsModel.fromJson(docPost.data()));
        docPost.reference
            .collection('likes')
            .snapshots().listen((event) {
          likes =0;
          for (var docLike in event.docs) {
            print(docLike.id);
            print('=============================\n');
            likes++;
            posts[index].likes=likes;
            emit(HomeCounterLikesState());
          }
          for (var docLike in event.docs) {
            if (docLike.id == userId) {
              like = true;
              emit(HomeSuccessLikeState());
              break;
            }
            else{
              like=false;
              emit(HomeSuccessUnLikeState());
            }
          }
          index++;

        });


      }
      emit(HomeSuccessGetPostsState());
    });
  }

  void getLikes(){

    FirebaseFirestore.instance
        .collection('posts' )
    .doc('3DWmyQgOgTfu16TETggS')
    .collection('likes')
    .snapshots()
    .listen((event) {
      event.docs.forEach((element) {
       print(element.id);
      });
    });

      print('==========================\n');
  }


  List<UserModel> users=[];
  void getUsersData(){
    users=[];
    emit(HomeLoadingGetUsersState());
    FirebaseFirestore.instance.collection('users')
        .get()
        .then((value) {
      for (var element in value.docs) {
        users.add(UserModel.fromJson(element.data()));
      }
      emit(HomeSuccessGetUsersState());
    }).catchError((error) {
      emit(HomeErrorGetUsersState(error.toString()));
    });


  }

  void likePost(String postId){
    like=!like;
    if(like){
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId).set({'like' : true, })
      .then((value){
      emit(HomeSuccessLikeState());
      }).catchError((error){
        emit(HomeErrorLikeState(error.toString()));

      });

    }
    else{
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId)
          .delete();
      emit(HomeSuccessUnLikeState());
    }

}


}