class UserModel {
  late String name;
  late String email;
  late String uId;
  late String phone;
  late bool male;
  String? bio;
   String? image;
   String? cover;
  late bool isEmailVerified;
  GeneralDetailsModel? generalDetails;

  UserModel({
    required this.name,
    required this.email,
    required this.uId,
    required this.phone,
    required this.male,
    this.bio,
    this.image,
    this.cover,
    required this.isEmailVerified,
    this.generalDetails,

  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    uId = json["uId"];
    phone = json["phone"];
    male = json["male"];
    bio = json["bio"];
    image = json["image"];
    cover = json["cover"];
    isEmailVerified = json["isEmailVerified"];
    generalDetails = GeneralDetailsModel.fromJson(json["generalDetails"]);
  }

  Map<String, dynamic> toMaP() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "uId": uId,
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
