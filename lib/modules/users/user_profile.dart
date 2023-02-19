// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/Home_cubit.dart';
import 'package:social_app/layout/Home/cubit/Home_states.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/layout/users/cubit/users_states.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/chats/chat_item.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/profile/general_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class UserProfileScreen extends StatelessWidget {
  late UserModel user;
  UserProfileScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(user.name) ,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {},
            builder: (context, state) {
             List<PostsModel> userPosts=[];
             for(int i=0;i< HomeCubit.get(context).posts.length;i++){
               if( HomeCubit.get(context).posts[i].uId==user.uId){
                 userPosts.add(HomeCubit.get(context).posts[i]);
               }}
              return Column(
                children: [
                  SizedBox(
                    height: 260.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              imageUrl: user.cover ?? '',
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    'assets/images/cover.jpg',
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 64,
                          backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 60.0,
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
                      ],
                    ),
                  ),
                 Padding(
                   padding: const EdgeInsets.all(5.0),
                   child: Column(
                     children: [
                       Text(
                         user.name,
                         style: Theme.of(context).textTheme.titleMedium,
                       ),
                       SizedBox(
                         height: 15.0,
                       ),
                       if (user.bio != null)
                         Text(
                           user.bio!,
                           style: Theme.of(context).textTheme.titleSmall,
                         ),
                       SizedBox(
                         height: 15.0,
                       ),
                       Row(
                         children: [
                           Expanded(
                             child: InkWell(
                               onTap: () {},
                               child: Column(
                                 children: [
                                   Text(
                                     '100',
                                     style: Theme.of(context)
                                         .textTheme
                                         .bodyMedium,
                                   ),
                                   Text(
                                     'posts',
                                     style:
                                     Theme.of(context).textTheme.bodySmall,
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           Expanded(
                             child: InkWell(
                               onTap: () {},
                               child: Column(
                                 children: [
                                   Text(
                                     '10K',
                                     style: Theme.of(context)
                                         .textTheme
                                         .bodyMedium,
                                   ),
                                   Text(
                                     'followers',
                                     style:
                                     Theme.of(context).textTheme.bodySmall,
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           Expanded(
                             child: InkWell(
                               onTap: () {},
                               child: Column(
                                 children: [
                                   Text(
                                     '500',
                                     style: Theme.of(context)
                                         .textTheme
                                         .bodyMedium,
                                   ),
                                   Text(
                                     'following',
                                     style:
                                     Theme.of(context).textTheme.bodySmall,
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ],
                       ),
                       SizedBox(height: 10.0,),
                       relation(),
                       SizedBox(height: 20.0,),
                       if (user.generalDetails != null)
                         Text(
                           'General Details',
                           style: Theme.of(context).textTheme.titleLarge!.copyWith(
                             color: secondaryColor[600],
                           ),
                         ),
                       SizedBox(
                         width: double.infinity,
                         child: generalDetails(
                           context: context,
                           model: user.generalDetails,
                         ),
                       ),
                       ListView.separated(
                         itemBuilder: (BuildContext context, int index) {
                           return FeedsScreen().buildPostItem(
                               context,
                               userPosts[index],
                               user);
                         },
                         separatorBuilder: (context, index) => SizedBox(
                           height: 20,
                         ),
                         itemCount: userPosts.length,
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                       ),
                       SizedBox(height: 100.0,),

                     ],
                   ),
                 ),
                ],
              );
            }),
      ),
    );
  }
  Widget relation()=>BlocConsumer<UsersCubit,UsersStates>(
    listener: (context, state) {},
    builder:(context, state) {
    return   StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uId)
          .collection('requests')
          .snapshots(),
      builder: (context, snapShots) {
        bool requestHim = false;
        if (snapShots.hasData) {
          for (var docReq in snapShots.data!.docs) {
            if (docReq.id == myId) {
              requestHim = true;
            }
          }
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(myId)
                .collection('requests')
                .snapshots(),
            builder: (context, snapShots) {
              bool requestMe = false;
              if (snapShots.hasData) {
                for (var docReq
                in snapShots.data!.docs) {
                  if (docReq.id == user.uId) {
                    requestMe = true;
                  }
                }
              }
              //if (requestHim)
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(myId)
                      .collection('friends')
                      .snapshots(),
                  builder: (context, snapShots) {
                    if (snapShots.hasData) {
                      bool accepted = false;
                      for (var docFriend
                      in snapShots.data!.docs) {
                        if (docFriend.id == user.uId) {
                          accepted = true;
                        }
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if(!accepted)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (!requestHim&&!requestMe)
                                  ElevatedButton(
                                    onPressed: () {
                                      UsersCubit.get(context)
                                          .sendRequest(user.uId,user.deviceToken);
                                    },
                                    style: ButtonStyle(
                                      padding: MaterialStatePropertyAll(
                                          EdgeInsets.zero),
                                      minimumSize: MaterialStatePropertyAll(
                                          Size(90, 25)),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Row(
                                      children: [
                                        Icon(Icons.person_add),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text('Add'),
                                      ],
                                    ),
                                  ),
                                if (!requestHim&&requestMe)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('He sent you a request'),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              UsersCubit.get(context).acceptFriend(user.uId,user.deviceToken);
                                            },
                                            style: ButtonStyle(
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.zero),
                                              minimumSize: MaterialStatePropertyAll(
                                                  Size(65, 25)),
                                            ),
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            child: Text('Accept'),
                                          ),
                                          SizedBox(width: 20.0,),
                                          OutlinedButton(
                                            onPressed: () {
                                              UsersCubit.get(context).deleteRequest(user.uId);
                                            },
                                            style: ButtonStyle(
                                              padding: MaterialStatePropertyAll(
                                                  EdgeInsets.zero),
                                              minimumSize: MaterialStatePropertyAll(
                                                  Size(65, 20)),
                                            ),
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                              ],
                            ),
                          if (!accepted&&requestHim)
                            OutlinedButton(
                              onPressed: () {
                                UsersCubit.get(context)
                                    .removeRequest(
                                    user.uId);
                              },
                              style: ButtonStyle(
                                padding:
                                MaterialStatePropertyAll(
                                    EdgeInsets.zero),
                                minimumSize:
                                MaterialStatePropertyAll(
                                    Size(65, 20)),
                              ),
                              child: Text('Remove'),
                            ),
                          if (accepted)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('you\'re friends '),
                                IconButton(onPressed:(){
                                  navigateAndReplace(context,ChatItemScreen(user));
                                }, icon: Icon(IconBroken.Chat)),
                              ],
                            ),
                        ],
                      );
                    } else {
                      return Text('wait ...');
                    }
                  });

            },
          );
        }
        else {return Text('wait ...');}
      },
    );

  },
  );
}
