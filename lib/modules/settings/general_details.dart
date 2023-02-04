// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:social_app/models/generalDetails_model.dart';


Widget generalDetails(context,GeneralDetailsModel model) {
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
  bool open=false;
  bool edit=false;
return Column(
  children: [
    if( schoolController.text.isNotEmpty)
    Row(
      children: [
        if(schoolController.text.isNotEmpty)
        Icon(Icons.workspace_premium),
        SizedBox(width: 5.0,),
        SizedBox(
          width: MediaQuery.of(context).size.width*.8,
          child: TextFormField(
            controller: schoolController,
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
    if(model.work!=null)
      Row(
        children: [
          if(workController.text.isNotEmpty)
            Icon(Icons.work_outlined),
          SizedBox(width: 5.0,),
          SizedBox(
            width: MediaQuery.of(context).size.width*.8,
            child: TextFormField(
              controller: schoolController,
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
    if(model.country!=null)
      Row(
        children: [
          if(schoolController.text.isNotEmpty)
            Icon(Icons.work_outlined),
          SizedBox(width: 5.0,),
          SizedBox(
            width: MediaQuery.of(context).size.width*.8,
            child: TextFormField(
              controller: schoolController,
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
    if(model.live!=null)
      Row(
        children: [
          if(schoolController.text.isNotEmpty)
            Icon(Icons.work_outlined),
          SizedBox(width: 5.0,),
          SizedBox(
            width: MediaQuery.of(context).size.width*.8,
            child: TextFormField(
              controller: schoolController,
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
    if(model.status!=null)
      Row(
        children: [
          if(schoolController.text.isNotEmpty)
            Icon(Icons.work_outlined),
          SizedBox(width: 5.0,),
          SizedBox(
            width: MediaQuery.of(context).size.width*.8,
            child: TextFormField(
              controller: schoolController,
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
