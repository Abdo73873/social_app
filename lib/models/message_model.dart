class MessageModel{
  late String senderId;
  late String receiverId;
  late String text;
    String? image;
  late String dateTime;
    late int indexMessage;
  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.dateTime,
    required this.indexMessage,
     this.image,

});
  MessageModel.fromJson(Map<String,dynamic> json){
    senderId=json['senderId'];
    receiverId=json['receiverId'];
    text=json['text'];
    dateTime=json['dateTime'];
    image=json['image'];
    indexMessage=json['indexMessage'];
  }

  Map<String,dynamic> toMap(){
    return{
      'senderId':senderId,
      'receiverId':receiverId,
      'text':text,
      'dateTime':dateTime,
      'image':image,
      'indexMessage':indexMessage,
    };
  }


}