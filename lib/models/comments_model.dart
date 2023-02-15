class CommentModel{
  late String uId;
  late String dateTime;
  late int indexComment;
  String? text;
  String? image;
  CommentModel({
    required this.uId,
    required this.dateTime,
    required this.indexComment,
    this.image,
    this.text,

  });
  CommentModel.fromJson(Map<String,dynamic> json){
    uId=json['uId'];
    text=json['text'];
    image=json['image'];
    dateTime=json['dateTime'];
    indexComment=json['indexComment'];
  }
  Map<String,dynamic> toMap(){
    return{
      'uId':uId,
      'text':text,
      'image':image,
      'dateTime':dateTime,
      'indexComment':indexComment,
    };
  }
}