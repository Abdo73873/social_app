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
                      GButton(icon: Icons.person_add_alt_1, text: 'Request',
                          leading:Stack(
                            alignment: AlignmentDirectional.topEnd,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: Icon( Icons.person_add,),
                          ),
                          CircleAvatar(
                            radius: 10,
                            child: Text('${cubit.requestsUid.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                              ),),
                          ),
                        ],
                      )),

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
