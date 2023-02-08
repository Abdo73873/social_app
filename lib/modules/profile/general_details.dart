// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:social_app/models/usersModel.dart';
import 'package:social_app/modules/profile/cubit/profile_cubit.dart';
import 'package:social_app/shared/components/constants.dart';


Widget generalDetails({
  required BuildContext context,
  required GeneralDetailsModel model,
}) {
  TextEditingController? schoolController = TextEditingController();
  TextEditingController? workController = TextEditingController();
  TextEditingController? countryController = TextEditingController();
  TextEditingController? liveController = TextEditingController();
  TextEditingController? statusController = TextEditingController();
  schoolController.text=model.school!;
  workController.text=model.work!;
  countryController.text=model.country!;
  liveController.text=model.live!;
  statusController.text=model.status!;
  var cubit=ProfileCubit.get(context);
  List<bool> readOnly=cubit.readOnly;
  double widthField=openToAdd?MediaQuery.of(context).size.width*.7:MediaQuery.of(context).size.width*.8;
  return Column(
  children: [
    if( model.school!.isNotEmpty||openToAdd)
    Row(
      children: [
        Icon(Icons.workspace_premium),
        SizedBox(width: 5.0,),
        SizedBox(
          width:widthField ,
          child: TextFormField(
            controller: schoolController,
            minLines: 1,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'study at',
            labelStyle: Theme.of(context).textTheme.labelLarge,

          ),
            readOnly:readOnly[3],
            textInputAction:TextInputAction.done ,
            onEditingComplete: (){
              model.school=schoolController.text;
              schoolController.text=model.school!;
              cubit.changeOpenEdit(3);
            },
            enabled: openToAdd,
          ),
        ),
        if(openToAdd)
        IconButton(
            onPressed: (){
              model.school=schoolController.text;
              schoolController.text=model.school!;
          cubit.changeOpenEdit(3);
        },
            icon: Icon(readOnly[3]?Icons.edit:Icons.done),
        ),

      ],
    ),
    if( model.work!.isNotEmpty||openToAdd)
      Row(
        children: [
          Icon(Icons.work_outlined),
          SizedBox(width: 5.0,),
          SizedBox(
            width:widthField ,
            child: TextFormField(
              controller: workController,
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                  labelText: 'work at',
                labelStyle: Theme.of(context).textTheme.labelLarge,

              ),
              readOnly:readOnly[4],
              textInputAction:TextInputAction.done ,
              onEditingComplete: (){
                model.work=workController.text;
                workController.text=model.work!;
                cubit.changeOpenEdit(4);
              },
              enabled: openToAdd,
            ),
          ),
          if(openToAdd)
            IconButton(
              onPressed: (){
                model.work=workController.text;
                workController.text=model.work!;
                cubit.changeOpenEdit(4);
              },
              icon: Icon(readOnly[4]?Icons.edit:Icons.done),
            ),

        ],
      ),
    if( model.country!.isNotEmpty||openToAdd)
      Row(
        children: [
          Icon(Icons.place),
          SizedBox(width: 5.0,),
          SizedBox(
            width:widthField ,
            child: TextFormField(
              controller: countryController,
              minLines: 1,
              maxLines: 2,
              decoration: InputDecoration(
                  labelText: 'from',
                labelStyle: Theme.of(context).textTheme.labelLarge,

              ),
              readOnly:readOnly[5],
              textInputAction:TextInputAction.done ,
              onEditingComplete: (){
                model.country=countryController.text;
                countryController.text=model.country!;
                cubit.changeOpenEdit(5);
              },
              enabled: openToAdd,
            ),
          ),
          if(openToAdd)
            IconButton(
              onPressed: (){
                model.country=countryController.text;
                countryController.text=model.country!;
                cubit.changeOpenEdit(5);
              },
              icon: Icon(readOnly[5]?Icons.edit:Icons.done),
            ),

        ],
      ),
    if( model.live!.isNotEmpty||openToAdd)
      Row(
        children: [
          Icon(Icons.home_work_outlined),
          SizedBox(width: 5.0,),
          SizedBox(
            width:widthField ,
            child: TextFormField(
              controller: liveController,
              minLines: 1,
              maxLines: 2,
              decoration: InputDecoration(
                  labelText: 'live in',
                labelStyle: Theme.of(context).textTheme.labelLarge,

              ),
              readOnly:readOnly[6],
              textInputAction:TextInputAction.done ,
              onEditingComplete: (){
                model.live=liveController.text;
                liveController.text=model.live!;
                cubit.changeOpenEdit(6);
              },
              enabled: openToAdd,
            ),
          ),
          if(openToAdd)
            IconButton(
              onPressed: (){
                model.live=liveController.text;
                liveController.text=model.live!;
                cubit.changeOpenEdit(6);
              },
              icon: Icon(readOnly[6]?Icons.edit:Icons.done),
            ),

        ],
      ),
    if( model.status!.isNotEmpty||openToAdd)
      Row(
        children: [
          Icon(Icons.workspace_premium),
          SizedBox(width: 5.0,),
          SizedBox(
            width:widthField ,
            child: TextFormField(
              controller: statusController,
              minLines: 1,
              maxLines: 2,
              readOnly:readOnly[7],
              textInputAction:TextInputAction.done ,
              onEditingComplete: (){
                model.status=statusController.text;
                statusController.text=model.status!;
                cubit.changeOpenEdit(7);
              },
              enabled: openToAdd,
            ),
          ),
          if(openToAdd)
            IconButton(
              onPressed: (){
                model.status=statusController.text;
                statusController.text=model.status!;
                cubit.changeOpenEdit(7);
              },
              icon: Icon(readOnly[7]?Icons.edit:Icons.done),
            ),

        ],
      ),
    SizedBox(height: 10.0,),
    if(model.school!.isEmpty||model.work!.isEmpty||model.country!.isEmpty||model.live!.isEmpty||model.status!.isEmpty)
      OutlinedButton(
        onPressed: (){
        cubit.changeToAdd();
        if(!openToAdd){
          cubit.updateUser();
        }
        },
        child: Row(
          children: [
            Icon(openToAdd?Icons.done:Icons.add_box,),
            SizedBox(width: 5.0,),
            Text(
              openToAdd?'Done': 'Add More General Details',
              style: Theme.of(context).textTheme.displayMedium,
            ),

          ],),
      ),
    SizedBox(height: 10.0,),
    if(model.school!.isNotEmpty&&model.work!.isNotEmpty&&model.country!.isNotEmpty&&model.live!.isNotEmpty&&model.status!.isNotEmpty)
      OutlinedButton(
      onPressed: (){
        cubit.changeToAdd();
        if(!openToAdd){
          cubit.updateUser();
        }
      },
      child: Row(
        children: [
        Icon(openToAdd?Icons.done:Icons.edit,),
        Text(
          openToAdd?'Done': 'edit General Details',
          style: Theme.of(context).textTheme.displayMedium,
        ),

      ],),
    ),
  ],
);

}

