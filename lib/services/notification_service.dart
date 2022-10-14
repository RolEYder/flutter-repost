//@dart=2.0
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> send_push_notification(String title, String body) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final tokenDevice = prefs.getString("tokenDevice");
  final post = http.post(
    Uri.parse("https://fcm.googleapis.com/fcm/send"),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAn-udz38:APA91bEHhdV7XVrwrKNFct1AprrOJX_gS7ElN5xSG_GAdayW8ztHohspO6yxmAaTiV8uQV0uEan6N72Hsdi1Z0akNK5glUdkdcR17yXsZD3RKIxN5Ugl9Rkytcnhk4juuXatyEQ0Nbec'
    },
    body: jsonEncode(<String, dynamic>{
      "to": tokenDevice.toString(),
      "priority": "high",
      "notification": {"body": body, "title": title}
    }),
  );
}
