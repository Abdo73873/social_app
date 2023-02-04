// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:social_app/models/usersModel.dart';


Widget generalDetails(context,GeneralDetailsModel model) {
  TextEditingController? schoolController = TextEditingController();
  TextEditingController? workController = TextEditingController();
  TextEditingController? countryController = TextEditingController();
  TextEditingController? liveController = TextEditingController();
  TextEditingController? statusController = TextEditingController();

  schoolController.text='study at ${model.school!}';
  workController.text='work at ${model.work!}';
 countryController.text='from ${model.country!}';
  liveController.text='live in ${model.live!}';
  statusController.text=model.status!;
  bool open=false;
  bool edit=false;
return Column(
  children: [
    if( model.school!.isNotEmpty)
    Row(
      children: [
        Icon(Icons.workspace_premium),
        SizedBox(width: 5.0,),
        SizedBox(
          width: MediaQuery.of(context).size.width*.8,
          child: TextFormField(
            controller: schoolController,
            minLines: 1,
            maxLines: 3,
            onTap: () {
              open=true;
            },
            onSaved: (value){
              model.country=countryController.text;
              open=true;
            },
            enabled: open,
          ),
        ),
      ],
    ),
    if( model.work!.isNotEmpty)
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Icon(Icons.work_outlined),
          SizedBox(width: 5.0,),
          SizedBox(
            width: MediaQuery.of(context).size.width*.8,
            child: TextFormField(
              minLines: 1,
              maxLines: 3,
              controller: workController,
              onTap: () {
                open=true;

              },
              onSaved: (value){
                open=true;
              },
              enabled: open,
            ),
          ),
        ],
      ),
    if( model.country!.isNotEmpty)
      Row(
        children: [
          if(countryController.text.isNotEmpty)
            Icon(Icons.place),
          SizedBox(width: 5.0,),
          SizedBox(
            width: MediaQuery.of(context).size.width*.8,
            child: TextFormField(
              controller: countryController,
              minLines: 1,
              maxLines: 2,
              onTap: () {
                open=true;

              },
              onSaved: (value){
                open=true;
              },
              enabled: open,
            ),
          ),
        ],
      ),
    if( model.live!.isNotEmpty)
      Row(
        children: [
          if(liveController.text.isNotEmpty)
            Icon(Icons.place),
          SizedBox(width: 5.0,),
          SizedBox(
            width: MediaQuery.of(context).size.width*.8,
            child: TextFormField(
              minLines: 1,
              maxLines: 2,
              controller: liveController,
              onTap: () {
                open=true;

              },
              onSaved: (value){
                open=true;
              },
              enabled: open,
            ),
          ),
        ],
      ),
    if( model.status!.isNotEmpty)
      Row(
        children: [
          if(statusController.text.isNotEmpty)
            Icon(Icons.favorite),
          SizedBox(width: 5.0,),
          SizedBox(
            width: MediaQuery.of(context).size.width*.8,
            child: TextFormField(
              controller: statusController,
              onTap: () {
                open=true;

              },
              onSaved: (value){
                open=true;
              },
              enabled: open,
            ),
          ),
        ],
      ),
    if(model.school!.isNotEmpty||model.work!.isNotEmpty||model.country!.isNotEmpty||model.live!.isNotEmpty||model.status!.isNotEmpty)
      OutlinedButton(
      onPressed: (){
        edit=!edit;
      },
      child: Row(
        children: [
        Icon(edit?Icons.done:Icons.edit,),
        Text(
          edit?'Done': 'edit General Details',
          style: Theme.of(context).textTheme.displayMedium,
        ),

      ],),
    ),
  ],
);

}

/*
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
generalDetails(),
Padding(
padding: const EdgeInsets.symmetric(vertical: 3.0),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(Icons.work_outlined),
Text(
'student at Mansoura university \n',
style: Theme.of(context).textTheme.displayMedium,
maxLines: 2,
overflow:TextOverflow.ellipsis,
),
],
),
),
Padding(
padding: const EdgeInsets.symmetric(vertical: 3.0),
child: Row(
children: [
Icon(Icons.workspace_premium),
Text(
'student at pharmacy ',
style: Theme.of(context).textTheme.displayMedium,
maxLines: 2,
overflow:TextOverflow.ellipsis,
),
],
),
),
Padding(
padding: const EdgeInsets.symmetric(vertical: 3.0),
child: Text(
'student at pharmacy ',
style: Theme.of(context).textTheme.displayMedium,
maxLines: 10,
overflow:TextOverflow.ellipsis,
),
),
Padding(
padding: const EdgeInsets.symmetric(vertical: 8.0),
child: Text(
'student at Mansoura university \n about me',
style: Theme.of(context).textTheme.displayMedium,
maxLines: 10,
overflow:TextOverflow.ellipsis,
),
),
SizedBox(height: 5.0,),

],
),*/
