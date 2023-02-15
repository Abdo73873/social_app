// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/layout/users/cubit/users_states.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/profile/general_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_app/modules/users/all_users_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

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
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  if (user.bio != null)
                    Text(
                      user.bio!,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
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
                  ),
                  relation(),
                  SizedBox(height: 20.0,),
                  if (user.generalDetails != null)
                    Text(
                      'General Details',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: secondaryColor[600],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: generalDetails(
                        context: context,
                        model: user.generalDetails,
                      ),
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

                ],
              );
            }),
      ),
    );
  }
  Widget relation()=>BlocConsumer<UsersCubit,UsersStates>(
    listener: (context, state) {},
    builder:(context, state) {
    return StreamBuilder(
      stream:FirebaseFirestore.instance
          .collection('users')
          .doc(user.uId)
          .collection('requests')
          .snapshots(),
      builder: (context,snapShots){
        bool isDone=false;
        if(snapShots.hasData){
          for (var docReq in snapShots.data!.docs) {
            if(docReq.id==myId){
              isDone=true;
            }
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!isDone)
              if(!isDone)
                ElevatedButton(
                  onPressed:(){
                    UsersCubit.get(context).sendRequest(user.uId);
                  },
                  style:ButtonStyle(
                    padding: MaterialStatePropertyAll(EdgeInsets.zero),
                    minimumSize: MaterialStatePropertyAll(Size(80,25)),
                  ) ,
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
              SizedBox(
                width: 20.0,
              ),
              if(isDone)
                StreamBuilder(
                    stream:FirebaseFirestore.instance
                        .collection('users')
                        .doc(myId)
                        .collection('friends')
                        .snapshots(),
                    builder: (context,snapShots){
                      if(snapShots.hasData){
                        bool  accepted=false;
                        for (var docFriend in snapShots.data!.docs) {
                          if(docFriend.id==user.uId){
                            accepted=true;
                          }
                        }

                        return Row(
                          children: [
                            if(!accepted)
                              Text('you sent a request '),
                            if(!accepted)
                             SizedBox(width: 20.0,),
                            if(!accepted)
                              OutlinedButton(
                                onPressed: () {
                                  UsersCubit.get(context).removeRequest(user.uId);
                                },
                                style: ButtonStyle(
                                  padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero),
                                  minimumSize:
                                  MaterialStatePropertyAll(Size(65, 20)),
                                ),
                                child: Text('Remove'),
                              ),
                            if(accepted)
                              Row(
                                children: [
                                  Text('you\'re friends '),
                                  SizedBox(width: 20.0,),
                                  OutlinedButton(
                                    onPressed: () {
                                      UsersCubit.get(context)
                                          .deleteFriend(user.uId);
                                    },
                                    style: ButtonStyle(
                                      padding:
                                      MaterialStatePropertyAll(EdgeInsets.zero),
                                      minimumSize:
                                      MaterialStatePropertyAll(Size(65, 20)),
                                    ),
                                    child: Row(
                                      children: [
                                        Text('Delete'),
                                        SizedBox(width: 5,),
                                        Icon(Icons.person_remove),
                                      ],
                                    ),
                                  ),

                                ],
                              ),

                          ],
                        );
                      }
                      else{return Text('wait ...');}
                    }
                ),

            ],
          );
        }
        else{return Text('wait ...');}
      },
    );
  },
  );
}