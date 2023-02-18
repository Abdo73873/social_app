class UserModel {
  late String name;
  late String email;
  late String uId;
   String? deviceToken;
  late String phone;
  late bool male;
  String? bio;
   late String image;
   String? cover;
  late bool isEmailVerified;
  GeneralDetailsModel? generalDetails;

  UserModel({
    required this.name,
    required this.email,
    required this.uId,
    required this.phone,
    required this.male,
     this.deviceToken,
    this.bio,
    required this.image,
    this.cover,
    required this.isEmailVerified,
    this.generalDetails,

  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    uId = json["uId"];
    deviceToken = json["deviceToken"];
    phone = json["phone"];
    male = json["male"];
    bio = json["bio"];
    image = json["image"];
    cover = json["cover"];
    isEmailVerified = json["isEmailVerified"];
    generalDetails = json["generalDetails"]!=null?GeneralDetailsModel.fromJson(json["generalDetails"]):null;
  }

  Map<String, dynamic> toMaP() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "uId": uId,
      "deviceToken": deviceToken,
      "male": male,
      "bio": bio,
      "image": image,
      "cover": cover,
      "isEmailVerified": isEmailVerified,
      "generalDetails":generalDetails!=null?generalDetails!.toMaP():null,

    };
  }
}

class GeneralDetailsModel {
  String? school;
  String? work;
  String? country;
  String? live;
  String? status;

  GeneralDetailsModel({
  this.school,
  this.work,
  this.country,
    this.live,
    this.status,
});
  GeneralDetailsModel.fromJson(Map<String, dynamic> json) {
    school = json["school"];
    work = json["work"];
    country = json["country"];
    live = json["live"];
    status = json["status"];
  }

  Map<String, dynamic> toMaP() {
    return {
      "school": school,
      "work": work,
      "country": country,
      "live": live,
      "status": status,
    };
  }
}
