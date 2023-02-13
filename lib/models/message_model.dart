class MessageModel{
  late String senderId;
  late String receiverId;
  late String text;
    String? image;
  late String dateTime;
    late String createdTime;
  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.dateTime,
    required this.createdTime,
     this.image,

});
  MessageModel.fromJson(Map<String,dynamic> json){
    senderId=json['senderId'];
    receiverId=json['receiverId'];
    text=json['text'];
    dateTime=json['dateTime'];
    image=json['image'];
    createdTime=json['createdTime'];
  }

  Map<String,dynamic> toMap(){
    return{
      'senderId':senderId,
      'receiverId':receiverId,
      'text':text,
      'dateTime':dateTime,
      'image':image,
      'createdTime':createdTime,
    };
  }


}