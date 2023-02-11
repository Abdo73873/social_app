// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/layout/users/cubit/users_states.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/shared/components/constants.dart';

class RequestsScreen extends StatelessWidget {

  TextEditingController searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit, UsersStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=UsersCubit.get(context);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder(
              stream:FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('requests')
              .snapshots(),
              builder:(context,snapShots){
                int length=0;
                if(snapShots.hasData) {
                  return ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index){
                      for (var docRequest in snapShots.data!.docs) {
                        if(cubit.users[index].uId==docRequest.id){
                          length++;
                          return buildChatItem(context,cubit.users[index] );
                        }
                      }return SizedBox();

                    },
                    separatorBuilder: (context, index) => SizedBox(height: 20.0,),
                    itemCount: length,
                  );
                }
                else{return Text('Loading data ... please wait');}
              } ,
            ),
          ),
        );
      },
    );
  }

  Widget buildChatItem(context, UserModel friend) => InkWell(
    onTap: (){
      //navigateTo(context, ChatItemScreen(friend));
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
                    SizedBox(height: 5.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed:(){
                          },
                          style:ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            minimumSize: MaterialStatePropertyAll(Size(65,25)),
                          ) ,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Text('Accept'),
                        ),
                        SizedBox(width: 20.0,),
                        OutlinedButton(
                          onPressed: (){},
                          style:ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            minimumSize: MaterialStatePropertyAll(Size(65,20)),
                          ) ,
                          child:Text('Delete'),
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
