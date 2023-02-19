// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:social_app/layout/Home/cubit/Home_cubit.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/search/search_screen.dart';

class SearchInPosts extends StatelessWidget {

  late PostsModel post;
  SearchInPosts(this.post);

  @override
  Widget build(BuildContext context) {

    for(int i=0;i<UsersCubit.get(context).users.length;i++){
      if(UsersCubit.get(context).users[i].uId==post.uId) {
        return  FeedsScreen().buildPostItem(context, post, UsersCubit.get(context).users[i]);
      }
    }
  return const SizedBox();
  }


}
