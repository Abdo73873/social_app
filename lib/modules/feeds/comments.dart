// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class CommentsScreen extends StatelessWidget {
  late String postId;
  TextEditingController commentController=TextEditingController();
  CommentsScreen(this.postId);

  @override
  Widget build(BuildContext context) {
    var cubit=HomeCubit.get(context);
    int limit =10;

    cubit.streamLikesAndComments(postId,limit);


    return BlocConsumer<HomeCubit,HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
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
                      '${cubit.likesCount}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Spacer(),
                    Text(
                      '${cubit.commentCount} comments',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ),
            titleSpacing: 0,
          ),
          body:  Column(
            children: [
              Expanded(
                child:Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RefreshIndicator(
                    onRefresh: (){
                      limit+=10;
                      return Future(() {
                          cubit.streamLikesAndComments(postId,limit);
                        },
                      );
                    },
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        for(int i=0;i<UsersCubit.get(context).users.length;i++){
                          if(UsersCubit.get(context).users[i].uId==cubit.comments[index].uId){
                            return buildCommentItem(context,cubit.comments[index],UsersCubit.get(context).users[i]);
                          }
                        }
                        return SizedBox();
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 20.0,),
                      itemCount: cubit.comments.length,
                    ),
                  ),
                ),
              ),
              if (state is! HomeCommentUploadImageLoadingState)
                if (cubit.commentImage != null)
                  Center(
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Image.file(
                          cubit.commentImage!,
                          height: 200,
                          width: double.infinity,
                        ),
                        IconButton(
                          onPressed: () {
                            cubit.removeCommentImage();
                          },
                          icon: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: defaultColor,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              if (!cubit.isUploadCommentImageComplete)
                CircularProgressIndicator(),
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
                                cubit.getCommentImage(false);
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
                                cubit.getCommentImage(true);
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
                              if(cubit.commentImage!=null||commentController.text.isNotEmpty){
                              if (cubit.commentImage != null) {
                              cubit.uploadCommentImage(
                              postId:postId
                              ,text: commentController.text);
                              cubit.isUploadCommentImageComplete == false;
                              } else {
                              cubit.addComment(postId:postId,text: commentController.text,);
                              }
                              commentController.clear();
                              }
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
          ),
        );
      },
    );
  }

  Widget buildCommentItem(context,CommentModel comment,UserModel user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              children: [
                Container(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height:5.0 ,),
                      Text('${comment.text}',
                          style: Theme.of(context).textTheme.bodyMedium),
                      if (comment.image != null)
                        if (comment.image!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CachedNetworkImage(
                              progressIndicatorBuilder: (context, url, progress) =>
                                  CircularProgressIndicator(),
                              imageUrl: comment.image!,
                              height: 300,
                              width: 250,
                              errorWidget: (context, url, error) =>
                                  Center(child: CircularProgressIndicator()),
                            ),
                          ),
                      SizedBox(height: 10.0,),
                      Text(comment.dateTime,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontSize: 9,
                        ),),

                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
