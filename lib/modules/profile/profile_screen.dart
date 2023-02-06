// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/usersModel.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import 'package:social_app/modules/profile/cubit/profile_states.dart';
import 'package:social_app/modules/profile/edit_profile.dart';
import 'package:social_app/modules/profile/general_details.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel userModel = HomeCubit.get(context).userModel;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: BlocConsumer<HomeCubit, HomeStates>(
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                children: [
                  SizedBox(
                    height: 200.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topStart,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                            child: CachedNetworkImage(
                              width: double.infinity,
                              height: 150,
                              fit: BoxFit.cover,
                              imageUrl: userModel.cover ?? '',
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                'assets/images/cover.jpg',
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 64,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 60.0,
                            child: ClipOval(
                              child: userModel.image!.isNotEmpty
                                  ? Image.network(
                                      userModel.image!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    userModel.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  if (userModel.bio != null)
                    Text(
                      userModel.bio!,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '100',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                                Text(
                                  'posts',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '10K',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                                Text(
                                  'followers',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Column(
                              children: [
                                Text(
                                  '500',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium,
                                ),
                                Text(
                                  'following',
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: defaultTextMatrialButton(
                        context: context,
                        text: 'Edit Profile',
                        onPressed: () {
                          navigateTo(context, EditProfileScreen());
                        }),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  BlocConsumer<ProfileCubit,ProfileStates>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: generalDetails(
                          context: context,
                          model: userModel.generalDetails!,
                        ),
                      );
                    },
                  ),

                ],
              );
            }),
      ),
    );
  }
}
