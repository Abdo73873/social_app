// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/usersModel.dart';
import 'package:social_app/modules/profile/edit_profile.dart';
import 'package:social_app/modules/profile/general_details.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        UserModel model = HomeCubit.get(context).userModel;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
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
                            imageUrl: model.cover ?? '',
                            errorWidget: (context, url, error) => Image.asset('assets/images/cover.jpg',
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
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  model.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 5.0,
                ),
                if (model.bio != null)
                  Text(
                    model.bio!,
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
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'post',
                                style: Theme.of(context).textTheme.bodySmall,
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
                                '100',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'follower',
                                style: Theme.of(context).textTheme.bodySmall,
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
                                '100',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'following',
                                style: Theme.of(context).textTheme.bodySmall,
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
                                '100',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'friends',
                                style: Theme.of(context).textTheme.bodySmall,
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
                if (model.generalDetails != null)
                  SizedBox(
                    width: double.infinity,
                    child: generalDetails(context, model.generalDetails!),
                  ),
                Text('hellooooooo'),
              ],
            ),
          ),
        );
      },
    );
  }
}
