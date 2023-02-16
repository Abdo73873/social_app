// ignore_for_file: use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/layout/Home/cubit/social_cubit.dart';
import 'package:social_app/models/userModel.dart';
import 'package:social_app/modules/users/user_profile.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';

class SearchScreen extends StatefulWidget {

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
@override
  void initState(){
  super.initState();

}

  List<UserModel> users=[];
      List posts=[];
void searchFromFireStore(String text){
 FirebaseFirestore.instance
      .collection('users')
      .get()
 .then((value){
   users=[];
   for (var docUser in value.docs) {

       if(docUser.data()['email'].toString().toLowerCase().contains(text.toLowerCase())) {
         if(docUser.data()['email']!=myModel.email){
           users.add(UserModel.fromJson(docUser.data()));
         }
       }
        else if(docUser.data()['name'].toString().toLowerCase().contains(text.toLowerCase())){
         if(docUser.data()['name']!=myModel.name){
           users.add(UserModel.fromJson(docUser.data()));

         }
     }
       else if(docUser.data()['phone'].toString().toLowerCase().contains(text.toLowerCase())){
         if(docUser.data()['phone']!=myModel.phone){
           users.add(UserModel.fromJson(docUser.data()));

         }
       }


     setState(() {});
   }


 });

  FirebaseFirestore.instance
      .collection('posts')
      .get()
      .then((value){
    posts=[];
    for (var docUser in value.docs) {
      if(docUser.data()['text'].toString().toLowerCase().contains(text.toLowerCase())){
        posts.add(docUser.data());
      }
      setState(() {});
    }
  });

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  height: 60.0,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: defaultFromField(
                      context: context,
                      action: TextInputAction.search,
                      controller: searchController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        return null;
                      },
                      onChange: (text) {
                        searchFromFireStore(text);
                      },
                      labelText: 'search',
                      prefix: Icons.search,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                if(searchController.text.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if(users.isNotEmpty)
                          ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => buildUserItem(users[index]),
                              separatorBuilder: (context, index) => const SizedBox(height: 20.0,),
                              itemCount: users.length
                          ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        if(posts.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => ListTile(title:Text(posts[index]['text'].toString()) ),
                            separatorBuilder: (context, index) => const SizedBox(height: 20.0,),
                            itemCount: posts.length
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

        },
      ),
    );
  }

  Widget buildUserItem(UserModel user)=> InkWell(
    onTap: (){
        navigateTo(context, UserProfileScreen(user));
    },
    child: Row(
      children: [
        CircleAvatar(
          radius: 25.0,
          child: ClipOval(
            child: CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              imageUrl: user.image,
              errorWidget: (context, url, error) => Image.asset(
                'assets/images/person.png',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 3.0,
              ),
              Text(
                user.email,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ],
    ),
  );

}
