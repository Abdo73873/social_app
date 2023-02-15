// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/models/userModel.dart';

class CommentsScreen extends StatelessWidget {

    late List<CommentModel> comment;
    late PostsModel postModel;
    late UserModel user;
    CommentsScreen(this.user,this.postModel);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream:FirebaseFirestore.instance.collection('users').doc(user.uId).collection('posts').snapshots(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildCommentItem();
                  },
                  separatorBuilder: (context, index) => SizedBox(
                        height: 10.0,
                      ),
                  itemCount: 10,
                );
              }
              return Text('field in get dada');
            },
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
  Widget buildCommentItem(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('comments'),
      ],
    );
  }
}
