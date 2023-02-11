// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables


import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/feeds/comments.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            UsersCubit.get(context).getUsersData();
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
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                    builder: (context, snapShot) {
                      late List<PostsModel> postModel=[];
                      if (snapShot.hasData) {
                        for (var docPost in snapShot.data!.docs) {
                          postModel.add(PostsModel.fromJson(
                              docPost.data() as Map<String, dynamic>));
                        }
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            for (int i = 0; i <UsersCubit.get(context).users.length; i++) {
                              if (postModel[index].uId == UsersCubit.get(context).users[i].uId) {
                                return buildPostItem(
                                    context, postModel[index], UsersCubit.get(context).users[i]);
                              }
                            }
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox(
                                height: 10.0,
                              ),
                          itemCount: postModel.length,
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
          ),
        );
      },
    );
  }

  Widget buildPostItem(context, PostsModel postModel, UserModel usModel) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: usModel.image,
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
                              usModel.name,
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
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 5.0,
                bottom: 10.0,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 6.0,
                      ),
                      child: SizedBox(
                        height: 25.0,
                        child: MaterialButton(
                            height: 25.0,
                            minWidth: 1.0,
                            padding: EdgeInsets.zero,
                            child: Text(
                              '#birthday',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.blue,
                                  ),
                            ),
                            onPressed: () {}),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 10.0,
                      ),
                      child: SizedBox(
                        height: 25.0,
                        child: MaterialButton(
                            height: 25.0,
                            minWidth: 1.0,
                            padding: EdgeInsets.zero,
                            child: Text(
                              '#birthday',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: Colors.blue,
                                  ),
                            ),
                            onPressed: () {}),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                      if(docLike.id==userId){liked=true;}
                      likes++;
                    }
                    return  Column(
                      children: [
                        Padding(
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
                                  '$likes',
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
                                    navigateTo(context, CommentsScreen(postModel));
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
                                      color: defaultColor,
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
                  return Text('Loading data ... please wait');
                },
              ),
          ],
        ),
      ),
    );
  }
}
