// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/layout/Home/cubit/social_states.dart';
import 'package:social_app/layout/Home/drower.dart';
import 'package:social_app/layout/users/cubit/users_cubit.dart';
import 'package:social_app/layout/users/cubit/users_states.dart';
import 'package:social_app/modules/new_post/cubit/posts_cubit.dart';
import 'package:social_app/modules/new_post/cubit/posts_states.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

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
                child: SafeArea(
                  child: GNav(
                    rippleColor: secondaryColor,
                    hoverColor: defaultColor,
                    gap: 6,
                    activeColor: defaultColor,
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    duration: Duration(milliseconds: 400),
                    tabBackgroundColor: secondaryColor.withOpacity(.1),
                    selectedIndex:cubit.currentIndex,
                    onTabChange: (index){
                      cubit.changeUsersBottomScreen(index);
                    },
                    tabs: [
                      GButton(icon: Icons.family_restroom, text: 'All',leading:Icon( Icons.family_restroom,) ,),
                      GButton(icon: Icons.person, text: 'Friends',leading: Icon(Icons.person),),
                      GButton(icon: Icons.person_add_alt_1, text: 'Request',leading:Icon( Icons.person_add_alt_1,)),

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
