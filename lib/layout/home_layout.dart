// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/layout/drower.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
      listener: (context,state){
        if(state is HomeNewPostState){
          navigateTo(context, NewPostScreen());

        }
      },
      builder: (context,state){
        var cubit=HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex],
            style: TextStyle(
              color: defaultColor,
            ),),
            actions: [
              IconButton(onPressed: (){
              }, icon: Icon(IconBroken.Notification,),),
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Search,),),
            ],
          ),
          drawer:NavigateDrawer(),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 6.0),
            child: SafeArea(
              child: GNav(
                rippleColor: secondaryColor,
                hoverColor: defaultColor,
                gap: 6,
                activeColor: defaultColor,
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: secondaryColor.withOpacity(.1),
                selectedIndex:cubit.currentIndex>=2?cubit.currentIndex+1:cubit.currentIndex,
                onTabChange: (index){
                  cubit.changeBottomScreen(index);
                },
                tabs: [
                  GButton(icon: IconBroken.Home, text: 'Home',),
                  GButton(icon: IconBroken.Chat, text: 'Chat',),
                  GButton(icon: Icons.add_box_outlined, text: 'Post',),
                  GButton(icon: IconBroken.Location, text: 'Users',),
                  GButton(icon: IconBroken.Profile, text: 'Profile',),

                ],
              ),
            ),
          ) ,
        );
      },
    );
  }
}

/*

Column(
children: [
if(!FirebaseAuth.instance.currentUser!.emailVerified)
Container(
color: Colors.amber.withOpacity(.6),
height: 50.0,
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 20.0),
child: Row(
children: [
Icon(Icons.info_outline),
SizedBox(width: 10.0,),
Expanded(child: Text('please verify your Email')),
defaultText(
text: "Send",
onPressed: (){
FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value){
showToast(message: "check your mail", state: ToastState.success);
}).catchError((error){
showToast(message: error.toString(), state: ToastState.error);
});
},
),
],
),
),
),
],
)*/
