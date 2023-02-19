// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/Home_cubit.dart';
import 'package:social_app/layout/Home/cubit/Home_states.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/layout/users/cubit/users_states.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/components/components.dart';

class FiendsScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UsersCubit.get(context).streamFriends();
    return BlocConsumer<UsersCubit, UsersStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UsersCubit.get(context);
        return Scaffold(
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
          body: Padding(
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
                SizedBox(
                  height: 20.0,
                ),
                if (searchController.text.isEmpty&&!cubit.foundFriend)
                  Expanded(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => ConditionalBuilder(
                        condition: cubit.friendsIds.isNotEmpty,
                        builder: (context) {
                          for (int i = 0;
                              i < UsersCubit.get(context).users.length;
                              i++) {
                            if (cubit.friendsIds[index] ==
                                UsersCubit.get(context).users[i].uId) {
                              return buildFriendItem(
                                  context, UsersCubit.get(context).users[i]);
                            }
                          }
                          return SizedBox();
                        },
                        fallback: (context) => CircularProgressIndicator(),
                      ),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 20,
                      ),
                      itemCount: cubit.friendsIds.length,
                    ),
                  ),
                if (searchController.text.isNotEmpty&&cubit.foundFriend)
                  Expanded(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildFriendItem(
                            context, cubit.friendsWhenSearch[index]);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: 20.0,
                      ),
                      itemCount: cubit.friendsWhenSearch.length,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildFriendItem(context, UserModel friend) => InkWell(
        onTap: () {
          navigateTo(context, UserProfileScreen(friend));
        },
        child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
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
                      children: [
                        Row(
                          children: [
                            Text(
                              friend.name,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.titleMedium,
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
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                UsersCubit.get(context)
                                    .deleteFriend(friend.uId);
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
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}
