// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/Home_cubit.dart';
import 'package:social_app/layout/Home/cubit/Home_states.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/layout/users/cubit/users_states.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

class AllUsersScreen extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit, UsersStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = UsersCubit.get(context);
        bool search = cubit.foundUser;
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
                      cubit.usersSearch(text);
                    },
                    labelText: 'search',
                    prefix: Icons.search,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              if (searchController.text.isEmpty)
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (cubit.users[index].uId != myId) {
                        return buildUserItem(
                            context, cubit.users[index], index);
                      } else {
                        return SizedBox();
                      }
                    },
                    separatorBuilder: (context, index) {
                      if (cubit.users[index].uId != myId) {
                        return SizedBox(
                          height: 20.0,
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                    itemCount: cubit.users.length,
                  ),
                ),
              if (searchController.text.isNotEmpty && search)
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildUserItem(
                        context, cubit.friendsWhenSearch[index], index),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 20.0,
                    ),
                    itemCount: cubit.friendsWhenSearch.length,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget buildUserItem(context, UserModel user, index) => InkWell(
        onTap: () {
          navigateTo(context, UserProfileScreen(user));
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              user.name,
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
                        StreamBuilder(
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
                                                          print('///////////${user.deviceToken}////////////');

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
                                                  Text('you\'re friends '),
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
