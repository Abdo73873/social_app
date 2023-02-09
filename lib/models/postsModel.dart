class PostsModel {
  late String name;
  late String uId;
  late String dateTime;
  late String image;
   int likes=0;
   int comments=0;
  String? text;
  String? postImage;

  PostsModel({
    required this.name,
    required this.uId,
    required this.dateTime,
    required this.image,
    this.text,
    this.postImage,
     this.likes=0,
     this.comments=0,
  });

  PostsModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    uId = json["uId"];
    image = json["image"];
    postImage = json["postImage"];
    dateTime = json["dateTime"];
    text = json["text"];

  }

  Map<String, dynamic> toMaP() {
    return {
      "name": name,
      "uId": uId,
      "dateTime": dateTime,
      "text": text,
      "image": image,
      "postImage": postImage,
    };
  }

}

