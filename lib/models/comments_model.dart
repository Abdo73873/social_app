class CommentModel{
  late String uId;
  late String text;
  late String image;
  CommentModel.fromJson(Map<String,dynamic> json){
    uId=json['uId'];
    text=json['text'];
    image=json['image'];
  }
  Map<String,dynamic> toMap(){
    return{
      'uId':uId,
      'text':text,
      'image':image,
    };
  }
}