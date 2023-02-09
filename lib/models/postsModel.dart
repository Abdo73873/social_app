class PostsModel {
  late String uId;
  late String dateTime;
  late String postId;
  String? text;
  String? postImage;
  List<String>? usersLiked;
   int countLikes=0;
   int comments=0;
  PostsModel({
    required this.uId,
    required this.dateTime,
    this.text,
    this.postImage,
    required this.postId,
  });

  PostsModel.fromJson(Map<String, dynamic> json) {
    uId = json["uId"];
    postImage = json["postImage"];
    dateTime = json["dateTime"];
    text = json["text"];
    postId = json["postId"];

  }

  Map<String, dynamic> toMaP() {
    return {
      "uId": uId,
      "dateTime": dateTime,
      "text": text,
      "postImage": postImage,
      "postId": postId,
    };
  }

}

