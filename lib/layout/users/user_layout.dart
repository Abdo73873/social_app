// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/layout/users/cubit/users_states.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:social_app/shared/styles/colors.dart';

class UsersLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersCubit,UsersStates>(
      listener: (context,state){},
      builder: (context,state){
        var cubit=UsersCubit.get(context);
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 6.0),
                child:    //private code here

                    tabs: [
                      GButton(icon: Icons.family_restroom, text: 'All',leading:Icon( Icons.family_restroom,) ,),
                      GButton(icon: Icons.person, text: 'Friends',leading: Icon(Icons.person),),
                      GButton(icon: Icons.person_add_alt_1, text: 'Request',
                            //private code here

                    ],
                  ),
                ),
              ) ,
              Expanded(
                  child:cubit.usersScreens[cubit.currentIndex],

              ),
            ],
          ),
        );
      },
    );
  }
}
