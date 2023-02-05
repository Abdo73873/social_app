// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/usersModel.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';
import 'package:image_picker/image_picker.dart';
class EditProfileScreen extends StatelessWidget {
  File? image;
  final picker=ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          UserModel model = HomeCubit.get(context).userModel;
          return Scaffold(
            appBar: defaultAppBar(
              context: context,
              actions: [
                defaultText(onPressed: () {}, text: 'Update'),
                SizedBox(
                  width: 10.0,
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
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
                                  imageUrl: model.cover ?? '',
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
                                    imageUrl: model.image ?? '',
                                    errorWidget: (context, url, error) => Image.asset(
                                      model.male
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
                ],
              ),
            ),
          );
        });
  }
}
