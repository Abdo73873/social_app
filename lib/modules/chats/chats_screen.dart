// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/Home_cubit.dart';
import 'package:social_app/layout/Home/cubit/Home_states.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/layout/users/cubit/users_states.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/chats/chat_item.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class ChatsScreen extends StatelessWidget {
  TextEditingController searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit, UsersStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=UsersCubit.get(context);
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 35.0,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: defaultFromField(
                    context: context,
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return null;
                    },
                    onChange: (text) {
                      cubit.friendsSearch(text);
                    },
                    labelText: 'search',
                    prefix: Icons.search,
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              if(searchController.text.isEmpty&&!cubit.foundFriend)
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index)=>ConditionalBuilder(
                      condition: cubit.friendsIds.isNotEmpty,
                      builder: (context) {
                        for (int i=0;i<UsersCubit.get(context).users.length;i++ ) {
                          if (cubit.friendsIds[index]==UsersCubit.get(context).users[i].uId) {
                            return streamBuildChatItem(
                                context, UsersCubit.get(context).users[i]);
                          }
                        }
                        return SizedBox();
                      },
                      fallback: (context) => CircularProgressIndicator(),
                    ),
                    separatorBuilder: (context, index)=> SizedBox(height: 20,),
                    itemCount:cubit.friendsIds.length ,
                  ),
                ),
              if(searchController.text.isNotEmpty&&cubit.foundFriend)
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return streamBuildChatItem(context, cubit.friendsWhenSearch[index]);
                    },
                    separatorBuilder: (context, index)=> SizedBox(height: 20.0,),
                    itemCount: cubit.friendsWhenSearch.length,
                  ),
                ),
            ],
          ),

        );
      },
    );
  }


  Widget streamBuildChatItem(context, UserModel friend) {
    return  InkWell(
      onTap: (){
        navigateTo(context, ChatItemScreen(friend));
      },
      child: BlocConsumer<HomeCubit,HomeStates>(
        listener: (context,state){},
        builder: (context,state){

          return Builder(
            builder: (context) {

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(myId)
                    .collection('friends')
                    .doc(friend.uId)
                    .collection('chat')
                    .where('senderId',isEqualTo: friend.uId)
                    .snapshots(),
                builder: (context, snapshot) {
                  String text = '';
                  String lastTime = '';
                  int last=0;
                  if(snapshot.hasData) {
                    for (var element in snapshot.data!.docs) {
                        if (element.data().isNotEmpty) {
                          if (int.parse(
                              element.data()['indexMessage'].toString()) >= last) {
                            lastTime =
                            element.data()['dateTime'].toString().split(' ')[1];
                            lastTime = '$lastTime ${element.data()['dateTime']
                                .toString()
                                .split(' ')[2]}';
                            text =
                                element.data()['text'].toString().substring(0,
                                    element.data()['text']
                                        .toString()
                                        .length );
                            last = int.parse(
                                element.data()['indexMessage'].toString());
                          }
                        }


                    }
                  }
                  return  buildChatItem(context,friend,text,lastTime);
                },
              );
              }
          );
        },
      ),
    );
  }
  Widget buildChatItem(context, UserModel friend,String text,String lastTime)=>Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: 30.0,
        child: ClipOval(
          child: CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            imageUrl: friend.image,
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/person.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friend.name,
                maxLines: 1,
                overflow:TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  if(lastTime.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    child: Container(
                      height: 8.0,
                      width: 8.0,
                      decoration: BoxDecoration(
                        color: defaultColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Text(
                    lastTime,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );

}
