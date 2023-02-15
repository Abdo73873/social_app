// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  late List<CommentModel> comment;
  late PostsModel postModel;
  late UserModel user;
  TextEditingController commentController=TextEditingController();
  CommentsScreen(this.user, this.postModel);

  @override
  Widget build(BuildContext context) {
    var cubit=HomeCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed:(){
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios),),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  IconBroken.Heart,
                  color: defaultColor,
                ),
                Text(
                  '0',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Spacer(),
                Text(
                  '${postModel.comments} comments',
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
        titleSpacing: 0,
      ),
      body: BlocConsumer<HomeCubit,HomeStates>(
        listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uId)
                        .collection('posts')
                        .snapshots(),
                    builder: (context, snapShot) {
                      if (snapShot.hasData) {
                        return ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildCommentItem(context);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10.0,
                          ),
                          itemCount: 10,
                        );
                      }
                      return Text('field in get data');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    vertical: 20.0,
                    horizontal: 5.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (commentController.text.isEmpty)
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .scaffoldBackgroundColor
                                .withOpacity(.9),
                            borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(10.0),
                              bottomStart: Radius.circular(10.0),
                            ),
                            border: Border.all(),
                          ),
                          child: Row(
                            children: [
                              MaterialButton(
                                padding: EdgeInsetsDirectional.all(.8),
                                minWidth: 1,
                                onPressed: () {
                                  cubit.getChatImage(false);
                                },
                                child: Icon(
                                  IconBroken.Camera,
                                  size: 25.0,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              MaterialButton(
                                padding: EdgeInsetsDirectional.all(.8),
                                minWidth: 1,
                                onPressed: () {
                                  cubit.getChatImage(true);
                                },
                                child: Icon(
                                  IconBroken.Image,
                                  size: 25.0,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: SizedBox(
                          height:
                          commentController.text.isEmpty ? 50.0 : null,
                          child: TextFormField(
                            onChanged: (value) {
                              HomeCubit.get(context).typing();
                            },
                            controller: commentController,
                            minLines: 1,
                            maxLines: 4,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context)
                                  .scaffoldBackgroundColor
                                  .withOpacity(1),
                              border: OutlineInputBorder(),
                              hintText: ' type your message here...',
                              hintStyle:
                              Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 45.0,
                        decoration: BoxDecoration(
                          color: defaultColor,
                          borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(10.0),
                            bottomEnd: Radius.circular(10.0),
                          ),
                          border: Border.all(),
                        ),
                        child: MaterialButton(
                          minWidth: 1,
                          padding: EdgeInsetsDirectional.all(.8),
                          onPressed: () {
                            if (cubit.commentImage != null) {
                              cubit.uploadCommentImage(postId: postModel.postId
                                  ,text: commentController.text);
                              //  cubit.isUploadCompleted == false;
                            } else {
                              cubit.addComment(postId: postModel.postId);
                            }
                            commentController.clear();
                          },
                          child: Icon(
                            Icons.send,
                            size: 25.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
      ),
    );
  }

  Widget buildCommentItem(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 27.0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: CircleAvatar(
            radius: 25.0,
            child: ClipOval(
              child: CachedNetworkImage(
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                imageUrl: user.image,
                errorWidget:(context,url,error)=> Image.asset(
                  user.male
                      ? 'assets/images/male.jpg'
                      : 'assets/images/female.jpg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 10.0,
            ),
            decoration: BoxDecoration(
              color:HomeCubit.get(context).isDark?Colors.grey[800]:Colors.grey[200],
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(15.0),
                topStart: Radius.circular(15.0),
                topEnd: Radius.circular(15.0),
              ),
            ),
            child: Column(
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text('message.text',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
