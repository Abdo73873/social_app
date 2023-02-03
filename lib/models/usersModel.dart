
class UserModel{
   late String name;
   late String email;
   late String uId;
    late String phone;
     late bool isEmailVerified;
  UserModel({
    required this.name,
    required this.email,
    required this.uId,
    required this.phone,
    this.isEmailVerified=false,
});

   UserModel.fromJson(Map<String,dynamic> json){
     name=json["name"];
     email=json["email"];
     uId=json["uId"];
     phone=json["phone"];
     isEmailVerified=json["isEmailVerified"];
   }

  Map<String,dynamic> toMaP(){
     return {
       "name":name,
       "email":email,
       "phone":phone,
       "uId":uId,
       "isEmailVerified":isEmailVerified,
     };
  }


}