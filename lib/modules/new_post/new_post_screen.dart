// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/layout/home_layout.dart';
import 'package:social_app/modules/new_post/cubit/posts_cubit.dart';
import 'package:social_app/modules/new_post/cubit/posts_states.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit, PostsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  navigateAndReplace(context, HomeLayout());
                },
                icon: Icon(Icons.arrow_back_ios)),
            title: Text('Create Post'),
            actions: [
              defaultText(text: "Post", onPressed: () {
                if(textController.text.isNotEmpty||PostsCubit.get(context).postImage!=null){
                  if(PostsCubit.get(context).postImage!=null){
                    PostsCubit.get(context).uploadImage(
                      text: textController.text,
                    );
                    navigateAndReplace(context, HomeLayout());
                  }
                  else{
                    PostsCubit.get(context).createPost(
                      text: textController.text,
                    );
                    navigateAndReplace(context, HomeLayout());
                  }
                  showToast(message:"publishing now", state: ToastState.success);
                }
                else {showToast(message:"write something", state: ToastState.warning);}

              }),
              SizedBox(
                width: 10.0,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is PostsLoadingState)
                  LinearProgressIndicator(
                    color: defaultColor,
                  backgroundColor: Colors.white,
                  ),
                SizedBox(height: 10.0,),
                Expanded(
                  child: SingleChildScrollView(
                    dragStartBehavior: DragStartBehavior.start,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      userModel.image,
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
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
                            SizedBox(
                              width: 20.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userModel.name,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                 DateFormat.yMd().add_jm().format(DateTime.now()),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          scrollPhysics: BouncingScrollPhysics(),
                          controller: textController,
                          minLines: 1,
                          maxLines: 20,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: "what do you think ?...",
                            hintStyle: Theme.of(context).textTheme.titleSmall,
                            border: InputBorder.none,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        if(PostsCubit.get(context).postImage!=null)
                        Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Image.file(PostsCubit.get(context).postImage!),
                            IconButton(onPressed: (){
                              PostsCubit.get(context).removeImage();
                            }, icon: CircleAvatar(
                              radius: 14.0,
                              backgroundColor:defaultColor,
                              child: Icon(Icons.close,
                              color: Colors.white,),
                            ),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              PostsCubit.get(context).getImage(false);
                            },
                            child:  Icon(IconBroken.Camera,size: 30.0,),

                          ),
                          TextButton(
                            onPressed: () {
                              PostsCubit.get(context).getImage(true);
                            },
                            child: Row(
                              children: [
                                Icon(IconBroken.Image,size: 30.0,),
                                Text("photo",),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "# Tags",
                      ),
                    )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
