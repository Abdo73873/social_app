// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/shared/components/components.dart';

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

  List searchResult=[];
void searchFromFireStore(String text){
  searchResult=[];
 FirebaseFirestore.instance
      .collection('users')
      .get()
 .then((value){
   for (var docUser in value.docs) {
     if(docUser.data()['name'].toString().toLowerCase().contains(text.toLowerCase())){
       searchResult.add(docUser.data());
     }
     setState(() {});
   }
 });
  FirebaseFirestore.instance
      .collection('posts')
      .get()
      .then((value){
    for (var docUser in value.docs) {
      if(docUser.data()['text'].toString().toLowerCase().contains(text.toLowerCase())){
        searchResult.add(docUser.data());
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => ListTile(title:Text(searchResult[index]['text'].toString()) ),
                            separatorBuilder: (context, index) => const SizedBox(height: 20.0,),
                            itemCount: searchResult.length
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => ListTile(title:Text(searchResult[index]['name'].toString()) ),
                            separatorBuilder: (context, index) => const SizedBox(height: 20.0,),
                            itemCount: searchResult.length
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
}
