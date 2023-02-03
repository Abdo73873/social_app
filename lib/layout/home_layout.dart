// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/shared/components/components.dart';

class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            title: Text('Home'),
          ),
          body: Column(
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
          ),
        );
      },
    );
  }
}
