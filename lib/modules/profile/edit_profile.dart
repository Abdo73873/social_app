// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import 'package:social_app/modules/profile/cubit/profile_states.dart';
import 'package:social_app/modules/profile/general_details.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/styles/colors.dart';

class EditProfileScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {


    }, builder: (context, state) {

      var cubit = ProfileCubit.get(context);
      File? profileImage = cubit.profileImage;
      File? coverImage = cubit.coverImage;

      nameController.text = myModel.name;
      bioController.text = myModel.bio??'';
      phoneController.text = myModel.phone;
      return Scaffold(
        appBar: defaultAppBar(
          context: context,
          actions: [
            defaultText(
                onPressed: () {
                  if(cubit.isUploadCompleted!=null){
                    if(cubit.isUploadCompleted!){
                      cubit.updateUser();
                      cubit.isUploadCompleted=null;
                      Navigator.pop(context);
                    }else{
                      showToast(message: "Wait for Uploading image", state: ToastState.warning);
                    }
                  }else{
                    cubit.updateUser();
                    Navigator.pop(context);
                  }
                  openToAdd=false;
                },
                text: 'Update'),
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
                if(state is ProfileUploadImageProfileLoadingState)
                LinearProgressIndicator(
                  color: defaultColor,
                  backgroundColor:Theme.of(context).scaffoldBackgroundColor,
                ),
                 SizedBox(
                  height: 200.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                              ),
                              child: coverImage == null
                                  ?  myModel.cover!=null
                                   ?CachedNetworkImage(
                                      width: double.infinity,
                                      height: 150,
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
                                    :  Image.asset(
                                'assets/images/cover.jpg',
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                                 : Image.file(
                                      coverImage,
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            addPic(context: context,namePic: "cover"),
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
                                child: profileImage == null
                                    ? CachedNetworkImage(
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
                                      )
                                    : Image.file(
                                        profileImage,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          addPic(context: context,namePic: "profile"),
                        ],
                      ),
                    ],
                  ),
                ),
                if (cubit.readOnly[0])
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          cubit.changeOpenEdit(0);
                        },
                        splashColor: secondaryColor,
                        highlightColor: secondaryColor,
                        child: Icon(
                          cubit.readOnly[0] ? Icons.edit : Icons.done,
                          size: 20.0,
                        ),
                      ),
                      Text(
                        '${myModel.name}    ',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                      ),
                    ],
                  ),
                if (!cubit.readOnly[0])
                  Form(
                    key: formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: TextFormField(
                            controller: nameController,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            readOnly: cubit.readOnly[0],
                            keyboardType: TextInputType.text,
                            textDirection:TextDirection.ltr ,
                            cursorRadius:Radius.circular(20.0) ,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Name must not be empty';
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              if (formKey.currentState!.validate()) {
                                myModel.name = nameController.text;
                                nameController.text = myModel.name;
                                cubit.changeOpenEdit(0);
                              }
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              myModel.name = nameController.text;
                              nameController.text = myModel.name;
                              cubit.changeOpenEdit(0);
                            }
                          },
                          icon:
                              Icon(cubit.readOnly[0] ? Icons.edit : Icons.done),
                        ),
                      ],
                    ),
                  ),
                if (cubit.readOnly[1])
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          cubit.changeOpenEdit(1);
                        },
                        splashColor: secondaryColor,
                        child: Icon(
                          cubit.readOnly[1] ? Icons.edit : Icons.done,
                          size: 20.0,
                        ),
                      ),
                      Text(
                        bioController.text.isNotEmpty
                            ? '${myModel.bio}    '
                            : 'bio ...   ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 5,
                      ),
                    ],
                  ),
                if (!cubit.readOnly[1])
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30.0,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: bioController,
                          minLines: 1,
                          maxLines: 5,
                          decoration: InputDecoration(labelText: 'Bio',
                            labelStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          readOnly: cubit.readOnly[1],
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            myModel.bio = bioController.text;
                            bioController.text = myModel.bio!;
                            cubit.changeOpenEdit(1);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          myModel.bio = bioController.text;
                          bioController.text = myModel.bio!;
                          cubit.changeOpenEdit(1);
                        },
                        icon: Icon(cubit.readOnly[1] ? Icons.edit : Icons.done),
                      ),
                    ],
                  ),
                if (cubit.readOnly[2])
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          cubit.changeOpenEdit(2);
                        },
                        splashColor: secondaryColor,
                        child: Icon(
                          cubit.readOnly[2] ? Icons.edit : Icons.done,
                          size: 20.0,
                        ),
                      ),
                      Text('${myModel.phone}    ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                      ),
                    ],
                  ),
                if (!cubit.readOnly[2])
                  Form(
                    key: formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30.0,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(labelText: 'Phone',
                              labelStyle: Theme.of(context).textTheme.labelLarge,
                            ),
                            readOnly: cubit.readOnly[2],
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Phone must not be empty';
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              if (formKey.currentState!.validate()) {
                                myModel.phone = phoneController.text;
                                phoneController.text = myModel.phone;
                                cubit.changeOpenEdit(2);
                              }
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              myModel.phone = phoneController.text;
                              phoneController.text = myModel.phone;
                              cubit.changeOpenEdit(2);
                            }
                          },
                          icon:
                          Icon(cubit.readOnly[2] ? Icons.edit : Icons.done),
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 50.0,
                ),
                if (myModel.generalDetails != null)
                  Text(
                    'General Details',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: secondaryColor[600],
                        ),
                  ),
                generalDetails(
                  context: context,
                  model: myModel.generalDetails,
                  forEdit: true,
                ),
                SizedBox(
                  height: 100.0,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }


  Widget addPic({
  required BuildContext context,
    required String namePic,
})=> Padding(
    padding: const EdgeInsets.all(8.0),
    child: CircleAvatar(
        radius: 15.0,
        backgroundColor: defaultColor[300],
        child: IconButton(
            color: Colors.white,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(.9),
                  shadowColor: defaultColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: Theme.of(context).iconTheme.color!,
                    ),
                  ),
                  actionsOverflowAlignment:
                  OverflowBarAlignment.center,
                  actionsPadding:
                  EdgeInsets.all(20.0),
                  elevation: 20.0,
                  title: Text(
                    'Choose Source :',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    OutlinedButton(
                      child: Row(
                        children: [
                          Icon(Icons.photo,
                          color: Theme.of(context).iconTheme.color!,),
                          SizedBox(
                            width: 30.0,
                          ),
                          Text(
                            "From Gallery",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                      onPressed: () {
                        if(namePic=="profile"){
                          ProfileCubit.get(context).getImage("profile", true);
                          Navigator.pop(context);
                        }
                        if(namePic=="cover"){
                          ProfileCubit.get(context).getImage("cover", true);
                          Navigator.pop(context);
                        }


                      },
                    ),
                    OutlinedButton(
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt,
                            color: Theme.of(context).iconTheme.color!,),
                          SizedBox(
                            width: 30.0,
                          ),
                          Text(
                            "From Camera",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium,
                          ),
                        ],
                      ),
                      onPressed: () {

                        if(namePic=="profile"){
                          ProfileCubit.get(context).getImage("profile", false);
                          Navigator.pop(context);
                        }
                        if(namePic=="cover"){
                          ProfileCubit.get(context).getImage("cover", false);
                          Navigator.pop(context);
                        }

                      },
                    ),
                  ],
                ),
              );
            },
            icon: Icon(
              Icons.camera_alt_rounded,
              color: Colors.white,
              size: 16.0,
            ))),
  );

}
