class CommentModel{
  late String uId;
   String? text;
   String? image;
  late String dateTime;
  CommentModel({
    required this.uId,
     this.text,
    required this.dateTime,
     this.image,
});
  CommentModel.fromJson(Map<String,dynamic> json){
    uId=json['uId'];
    text=json['text'];
    image=json['image'];
    dateTime=json['dateTime'];
  }
  Map<String,dynamic> toMap(){
    return{
      'uId':uId,
      'text':text,
      'image':image,
      'dateTime':dateTime,
    };
  }
}