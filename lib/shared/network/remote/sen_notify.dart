
import 'dart:convert';

import 'package:http/http.dart' as http;


Future<void> sendNotify({
  required String to,
  required String title,
  required String message,
  required String userId,
  required String name,
  required String image,
})async{

    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "key=AAAAbVqX9Lw:APA91bEExzxXpBUORyIoLEy9UHApxyilpH4-MActFVfRTdZzNnoikjCfHiOomWWNHxfLXGLhigyMAGbT1s-1felfGCtulZe1SCqKUTrY8cVWHtm4B5S4XJaG97mBU28NuZBT0nG8mUlS ",

      },
      body: jsonEncode({
        "to":to,
        "notification":{
          "title":title,
          "body":message,
          "sound":"defualt"

        },
        "android":{
          "priority":"HIGH",
          "notification":{
            "notification_priority":"priority_MAX",
            "sound":"defualt",
            "defualt_sound":"true",
            "defualt_vibrate_timings":"true",
            "defualt_ligt_settings":"true"

          }

        },
        "data":{
      "click_action":"FLUTTER_NOTIFICATOIN_CLICK",
      "type":"order",
          "id":userId,
          "name":name,
          "image":image,
        }
      }),
    );
    print('FCM request for device sent!');


}

