

import 'package:social_app/models/usersModel.dart';

void printFullText(String text){
  final pattern=RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}

String? userId='';
bool openToAdd=false;
late  UserModel userModel;
