// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/layout/cubit/social_cubit.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/styles/colors.dart';

class NavigateDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit=HomeCubit.get(context);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
          alignment: AlignmentDirectional.bottomEnd,
            children: [
              Container(
                width: double.infinity,
                color: defaultColor.withOpacity(.5),
                padding:  EdgeInsets.only(
                  left: 10.0,
                  top: 20+ MediaQuery.of(context).padding.top,
                  bottom: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 38.0,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: userModel.image,
                            errorWidget:(context,url,error)=> Image.asset(
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
                    SizedBox(height: 10.0,),
                    Text(
                      userModel.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Bassant",
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Text(
                      userModel.phone,
                      style: TextStyle(
                        color: secondaryColor[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                child: IconButton(
                  icon: Icon(
                    cubit.isDark?Icons.sunny:Icons.dark_mode,
                    color: cubit.isDark?Colors.amber:Colors.white,
                    size: 35.0,
                  ),
                  onPressed: () {
                    cubit.changeMode();
                  },
                ),

              ),

            ],
          ),
         /* Wrap(
            runSpacing: 20.0,
            children: [
              ListTile(
                onTap: (){},
                leading: Icon(Icons.logout),
                title: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

            ],
          ),*/
          Spacer(),
          ListTile(
            onTap: (){
              CacheHelper.removeData(key: "uId").then((value){
                navigateAndFinish(context, LoginScreen());
              });
            },
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 5.0,),
        ],
      ),
    );
  }
}
