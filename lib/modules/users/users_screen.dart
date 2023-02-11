// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/shared/components/constants.dart';

class UsersScreen extends StatelessWidget {

  TextEditingController searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit=HomeCubit.get(context);
        bool search=cubit.found;
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.0,
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 1.0,
                    ),
                    hintText: 'search',
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ),
                    ),
                  ),
                  onChanged: (text){
                    cubit.chatSearch(text);

                  },
                ),
              ), // search
              SizedBox(
                height: 15.0,
              ),
              if(searchController.text.isEmpty)
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (cubit.users[index].uId != userId) {
                        return buildChatItem(context, cubit.users[index]);
                      }else{return SizedBox();}
                    },
                    separatorBuilder: (context, index) {
                      if (HomeCubit.get(context).users[index].uId != userId) {
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
              if(searchController.text.isNotEmpty&&search)
                Expanded(
                  child: ListView.separated(
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildChatItem(context, cubit.friendsWhenSearch[index]),
                    separatorBuilder: (context, index) => SizedBox(height: 20.0,),

                    itemCount:  cubit.friendsWhenSearch.length,
                  ),
                ),
            ],
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
                          onPressed:(){},
                          style:ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            minimumSize: MaterialStatePropertyAll(Size(45,25)),
                          ) ,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Text('Add'),
                        ),
                        SizedBox(width: 20.0,),
                        OutlinedButton(
                          onPressed: (){},
                          style:ButtonStyle(
                            padding: MaterialStatePropertyAll(EdgeInsets.zero),
                            minimumSize: MaterialStatePropertyAll(Size(65,2)),
                          ) ,
                        child:Text('Remove'),
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
