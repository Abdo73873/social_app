// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class ChatItemScreen extends StatelessWidget {
late UserModel friend;
ChatItemScreen(this.friend);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        titleSpacing: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              child: ClipOval(
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: friend.image,
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/person.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
              SizedBox(width: 15.0,),
            Text(
              friend.name,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleMedium,
            ),


          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadiusDirectional.only(
                          bottomEnd: Radius.circular(15.0),
                          topStart: Radius.circular(15.0),
                          topEnd: Radius.circular(15.0),
                        ),
                      ),
                      child: Text('hello world',
                      style: TextStyle(
                          color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: defaultColor.withOpacity(.9),
                        borderRadius: BorderRadiusDirectional.only(
                          bottomStart: Radius.circular(15.0),
                          topStart: Radius.circular(15.0),
                          topEnd: Radius.circular(15.0),
                        ),
                      ),
                      child: Text('hello world',
                      style: TextStyle(
                          color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 20.0,horizontal: 5.0,),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 50,
                  width: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(10.0),
                      bottomStart: Radius.circular(10.0),
                    ),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: MaterialButton(
                    padding: EdgeInsetsDirectional.all(.8),
                    minWidth: 1,
                    onPressed: () {
                    },
                    child: Icon(IconBroken.Camera,size: 20.0,color: defaultColor,),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,

                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ' type your message here...',
                        hintStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 45.0,
                  decoration: BoxDecoration(
                    color: defaultColor,
                    borderRadius: BorderRadiusDirectional.only(
                      topEnd: Radius.circular(10.0),
                      bottomEnd: Radius.circular(10.0),
                    ),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: MaterialButton(
                    minWidth: 1,
                    padding: EdgeInsetsDirectional.all(.8),
                    onPressed: () {
                    },
                    child:  Icon(Icons.send,size: 25.0,color: Colors.white,),

                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
