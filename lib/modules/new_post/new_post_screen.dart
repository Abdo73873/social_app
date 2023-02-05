// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';

class NewPostScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
        listener: (context,state){},
        builder:  (context,state){
          return  Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: (){
                    HomeCubit.get(context).changeBottomScreen(HomeCubit.get(context).perIndex);
                    Navigator.of(context).pop();

                  },
                  icon: Icon(Icons.arrow_back_ios)),
            ),
            body:  Column(
              children: [
                Text('add post'),
              ],
            ),
          );
        },
      );

  }
}
