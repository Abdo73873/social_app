// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Column(
          children: [
            Text('chats'),
            Container(
              width: 50.0,
              height: 2000,
              color: Colors.red,
            )
          ],
        ),
      ],
    );
  }
}
