// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/layout/users/cubit/users_states.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/chats/chat_item.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

class ChatsScreen extends StatelessWidget {
  TextEditingController searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocConsumer<UsersCubit,UsersStates>(
            listener: (context, state) {},
            builder: (context, state) {
              var cubit=UsersCubit.get(context);
              return Column(
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
                                return buildChatItem(
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
                          return buildChatItem(context, cubit.friendsWhenSearch[index]);
                        },
                        separatorBuilder: (context, index)=> SizedBox(height: 20.0,),
                        itemCount: cubit.friendsWhenSearch.length,
                      ),
                    ),
                ],
              );
            },
          ),

        );
      },
    );
  }

  Widget buildChatItem(context, UserModel friend) => InkWell(
    onTap: (){
      navigateTo(context, ChatItemScreen(friend));
    },
    child: BlocConsumer<HomeCubit,HomeStates>(
      listener: (context,state){},
      builder: (context,state){
        return Row(
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'hi, i\'m here ',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: Container(
                            height: 8.0,
                            width: 8.0,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Text(
                          '10:05pm',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );

}
