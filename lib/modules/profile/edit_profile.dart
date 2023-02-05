// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/models/usersModel.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import 'package:social_app/modules/profile/cubit/profile_states.dart';
import 'package:social_app/modules/profile/general_details.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:image_picker/image_picker.dart';
class EditProfileScreen extends StatelessWidget {
  File? image;
  final picker=ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {},
        builder: (context, state) {
          UserModel userModel = HomeCubit.get(context).userModel;
          return Scaffold(
            appBar: AppBar(
              leading:IconButton(
                onPressed: (){
                  ProfileCubit.get(context).changeToAdd(context: context, isEditScreen: false);
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back_ios),
              ) ,
              actions: [
                defaultText(onPressed: () {
                  ProfileCubit.get(context).changeToAdd(
                      context: context,
                      isEditScreen: false);
                  Navigator.pop(context);

                }, text: 'Update'),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Stack(
                              alignment:AlignmentDirectional.topEnd ,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                  ),
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    imageUrl: userModel.cover ?? '',
                                    errorWidget: (context, url, error) => Image.asset('assets/images/cover.jpg',
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 20.0,
                                      backgroundColor: defaultColor[300],
                                      child: IconButton(
                                        color: Colors.white,
                                          onPressed: () {},
                                          icon: Icon(Icons.camera_alt_rounded,
                                          color: Colors.white,))),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64,
                                backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      imageUrl: userModel.image ?? 'http://',
                                      errorWidget: (context, url, error) => Image.asset(
                                        userModel.male
                                            ? 'assets/images/male.jpg'
                                            : 'assets/images/female.jpg',
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    radius: 17.0,
                                    backgroundColor: defaultColor[300],
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.camera_alt_rounded,
                                          color: Colors.white,
                                        size: 20.0,))),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    generalDetails(
                      context: context,
                      model:userModel.generalDetails!,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
