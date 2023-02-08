class PostsModel {
  late String name;
  late String uId;
  late String dateTime;
  String? text;
  String? image;
  String? postImage;

  PostsModel({
    required this.name,
    required this.uId,
    required this.dateTime,
    this.image,
    this.text,
    this.postImage,
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

