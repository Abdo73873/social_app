// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/Home/cubit/Home_cubit.dart';
import 'package:social_app/layout/Home/cubit/Home_states.dart';
import 'package:social_app/models/postsModel.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/new_post/new_post_screen.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import 'package:social_app/modules/profile/cubit/profile_states.dart';
import 'package:social_app/modules/profile/edit_profile.dart';
import 'package:social_app/modules/profile/general_details.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: BlocConsumer<HomeCubit, HomeStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: [
                if (state is HomeLoadingGetUserState)
                  LinearProgressIndicator(
                    color: defaultColor,
                    backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                  ),
                SizedBox(
                  height: 260.0,
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
                          child: myModel.cover != null
                              ? CachedNetworkImage(
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            imageUrl: myModel.cover!,
                            errorWidget: (context, url, error) =>
                                Image.asset(
                                  'assets/images/cover.jpg',
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                          )
                              : Image.asset(
                            'assets/images/cover.jpg',
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
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
                              imageUrl: myModel.image,
                              errorWidget: (context, url, error) =>
                                  Image.asset(
                                    myModel.male
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
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Column(
                   children: [
                     Text(
                       myModel.name,
                       style: Theme.of(context).textTheme.titleMedium,
                     ),
                     SizedBox(
                       height: 5.0,
                     ),
                     if (myModel.bio != null)
                       Text(
                         myModel.bio!,
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
                                     'posts',
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
                                     '10K',
                                     style: Theme.of(context).textTheme.bodyMedium,
                                   ),
                                   Text(
                                     'followers',
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
                                     '500',
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
                     BlocConsumer<ProfileCubit, ProfileStates>(
                       listener: (context, state) {
                         if (state is ProfileUpdateSuccessState) {
                           HomeCubit.get(context).getMyData();
                         }
                       },
                       builder: (context, state) {
                         List<PostsModel> myPosts=[];
                         for(int i=0;i< HomeCubit.get(context).posts.length;i++){
                           if( HomeCubit.get(context).posts[i].uId==myId){
                             myPosts.add(HomeCubit.get(context).posts[i]);
                           }}
                         return Column(
                           children: [
                             SizedBox(
                               width: double.infinity,
                               child: generalDetails(
                                 context: context,
                                 model: myModel.generalDetails,
                                 forEdit: true,
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 10.0),
                               child: Row(
                                 children: [
                                   CircleAvatar(
                                     radius: 20.0,
                                     child: ClipOval(
                                       child: CachedNetworkImage(
                                         width: double.infinity,
                                         height: double.infinity,
                                         fit: BoxFit.cover,
                                         imageUrl: myModel.image,
                                         errorWidget: (context, url, error) =>
                                             Image.asset(
                                               myModel.male
                                                   ? 'assets/images/male.jpg'
                                                   : 'assets/images/female.jpg',
                                               width: double.infinity,
                                               height: double.infinity,
                                               fit: BoxFit.cover,
                                             ),
                                       ),
                                     ),
                                   ),
                                   SizedBox(
                                     width: 10.0,
                                   ),
                                   Expanded(
                                     child: OutlinedButton(
                                       onPressed: (){
                                         navigateTo(context, NewPostScreen());
                                       },
                                       style: ButtonStyle(
                                         alignment: AlignmentDirectional.centerStart,
                                         side: MaterialStatePropertyAll(
                                           BorderSide(color: secondaryColor),
                                         ),
                                         shape: MaterialStatePropertyAll(
                                             RoundedRectangleBorder(
                                               borderRadius: BorderRadius.circular(25.0),)),
                                       ),
                                       child: Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Text(
                                           'What\'s on your mind?...',
                                           textAlign: TextAlign.start,
                                           style: Theme.of(context).textTheme.titleSmall,
                                         ),
                                       ),
                                     ),
                                   ),
                                   SizedBox(width: 10.0,),
                                   Icon(Icons.image,color: defaultColor,),
                                   SizedBox(width: 10.0,),

                                 ],
                               ),
                             ),
                             SizedBox(height: 20.0,),
                             ListView.separated(
                               itemBuilder: (BuildContext context, int index) {
                                 return FeedsScreen().buildPostItem(
                                     context,
                                     myPosts[index],
                                     myModel);
                               },
                               separatorBuilder: (context, index) => SizedBox(
                                 height: 20,
                               ),
                               itemCount: myPosts.length,
                               shrinkWrap: true,
                               physics: NeverScrollableScrollPhysics(),
                             ),
                           ],
                         );
                       },
                     ),

                   ],
                 ),
               ),
              ],
            );
          }),
    );
  }

}
