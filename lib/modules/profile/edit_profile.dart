// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/layout/cubit/social_states.dart';
import 'package:social_app/models/usersModel.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
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
            body: SizedBox(
              height: 190.0,
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Stack(
                      alignment:AlignmentDirectional.topEnd ,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 140.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(model.cover ??
                                  'https://img.freepik.com/free-photo/photo-delighted-african-american-woman-points-away-with-both-index-fingers-promots-awesome-place-your-advertising-content_273609-27157.jpg'),
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
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(model.image ??
                              'https://img.freepik.com/free-photo/young-woman-with-afro-haircut-wearing-orange-sweater_273609-22398.jpg?w=900&t=st=1675442690~exp=1675443290~hmac=c7aea7072ec4dbf5d2fe566934754c6a57ca4fa9aa3578c7a33aaf7df8419633'),
                          radius: 60.0,
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
          );
        });
  }
}
