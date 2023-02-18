// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable


import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/layout/Home/home_layout.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/feeds/comments.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  double? numOfPost;
  FeedsScreen({this.numOfPost});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        late final ScrollController scrollController = ScrollController();
        int limit = 20;
        scrollController.addListener(() {
          if (scrollController.hasClients) {
            if (scrollController.position.maxScrollExtent -
                scrollController.position.pixels == 0) {
              limit += 20;
              HomeCubit.get(context).getPosts(limit);
            }
          }
        });
        return RefreshIndicator(
          onRefresh: () async {
            UsersCubit.get(context).streamGetUsersData();
          },
          child: SingleChildScrollView(
            controller: scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 10.0,
                  margin: EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image(
                        width: double.infinity,
                        height: 200.0,
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            'https://img.freepik.com/free-photo/photo-delighted-african-american-woman-points-away-with-both-index-fingers-promots-awesome-place-your-advertising-content_273609-27157.jpg'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'communicate with friends',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color: Colors.white,
                                backgroundColor: secondaryColor.withOpacity(.1),
                                height: 1.0,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (UsersCubit.get(context).users.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      for (int i = 0; i <UsersCubit.get(context).users.length; i++) {
                        if (HomeCubit.get(context).posts[index].uId == UsersCubit.get(context).users[i].uId) {
                          return buildPostItem(
                              context, HomeCubit.get(context).posts[index], UsersCubit.get(context).users[i]);
                        }
                      }
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(
                          height: 10.0,
                        ),
                    itemCount: HomeCubit.get(context).posts.length,
                  ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPostItem(context, PostsModel postModel, UserModel user) {
    return Card(
      key:key ,
      color: Theme.of(context).scaffoldBackgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                if(user.uId==myId){
                  HomeCubit.get(context).changeBottomScreen(4);
                  navigateAndReplace(context, HomeLayout());
                }
                else{
                  navigateTo(context, UserProfileScreen(user));

                }

              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: user.image,
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/person.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 18.0,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          postModel.dateTime,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_horiz,
                      size: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                height: 2.0,
                color: secondaryColor,
              ),
            ),
            if (postModel.text != null)
              Text(
                postModel.text!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            SizedBox(height: 20.0,),
            if (postModel.postImage!.isNotEmpty)
              Container(
                width: double.infinity,
                height: 140.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                    image: NetworkImage(postModel.postImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:FirebaseFirestore.instance.collection('posts').doc(postModel.postId).collection('likes').snapshots(),
                builder: (context,snapshot){
                  bool liked=false;
                  int likes=0;
                  if(snapshot.hasData) {
                    for (var docLike in snapshot.data!.docs) {
                      if(docLike.id==myId){liked=true;}
                      likes++;
                    }
                    return StreamBuilder<QuerySnapshot>(
                      stream:FirebaseFirestore.instance.collection('posts').doc(postModel.postId).collection('comments').snapshots(),
                                builder: (context,snapshot) {
                                  int comments = 0;
                                  if (snapshot.hasData) {
                                    for (var docLike in snapshot.data!.docs) {
                                      if (docLike.id == myId) {
                                        liked = true;
                                      }
                                      comments++;
                                    }
                                  }
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Icon(
                                                IconBroken.Heart,
                                                color: Colors.purple,
                                              ),
                                              Text(
                                                '$likes',
                                                style: Theme.of(context).textTheme.titleSmall,
                                              ),
                                              Spacer(),
                                              Text(
                                                '$comments comments',
                                                textAlign: TextAlign.end,
                                                style: Theme.of(context).textTheme.titleSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 2.0,
                                        color: secondaryColor,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  navigateTo(context, CommentsScreen( postModel.postId));
                                                },
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20.0,
                                                      child: ClipOval(
                                                        child: CachedNetworkImage(
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                          fit: BoxFit.cover,
                                                          imageUrl: myModel.image,
                                                          errorWidget: (context, url, error) =>
                                                              Image.asset(
                                                                myModel.male
                                                                    ? 'assets/images/male.jpg'
                                                                    : 'assets/images/female.jpg',
                                                                width: double.infinity,
                                                                height: double.infinity,
                                                                fit: BoxFit.cover,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Text(
                                                      'write a comment ...',
                                                      textAlign: TextAlign.start,
                                                      style: Theme.of(context).textTheme.titleSmall,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            MaterialButton(
                                              minWidth: 1.0,
                                              padding: EdgeInsets.symmetric(horizontal: 3.0),
                                              onPressed: () {
                                                HomeCubit.get(context).likePost(postModel.postId);
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    IconBroken.Heart,
                                                    color: Colors.purple,
                                                    size: 18.0,
                                                  ),
                                                  Text(
                                                    liked ? ' liked' : ' Like',
                                                    style: Theme.of(context).textTheme.titleSmall,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                    );
                  }
                  return Text('Loading data ... please wait');
                },
              ),
          ],
        ),
      ),
    );
  }
}
