import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class StoryService {
  /// Function to get all recent stories giving username
  /// @_username [String] username
  Future<List<dynamic>?> getStoriesByUserUsername(String _username) async {

      List<dynamic> dataParsed = [];
      //first at all, get the user id by their username
      var url =
          "https://instagram-scraper-2022.p.rapidapi.com/ig/user_id/?user=" +
              _username;
      var dio = Dio();
      //building GET request headers
      dio.options.headers['X-RapidAPI-Key'] =
          "cb42a464cbmsh5d08b3d42135b64p1de875jsn9ef075c0c463";
      dio.options.headers['X-RapidAPI-Host'] =
          "instagram-scraper-2022.p.rapidapi.com";
      dio.options.headers['X-RapidAPI-Key'] =
          "9da44fc6ddmsh37b9e8973436610p10ab16jsnf989eb4c232a";
      dio.options.headers['X-RapidAPI-Host'] =
          "instagram-scraper-2022.p.rapidapi.com";
      dio.options.headers["Cookie"] = "PHPSESSID=bcmf0d1qph5houlg8k8qo3fm1l";
      dio.options.headers["Cache-Control"] = "no-cache";
      dio.options.headers["Accept"] = "*/*";
      dio.options.headers["Accept-Encoding"] = "gzip, deflate, br, json";
      var responseId = await dio.get(url);
      if (responseId.statusCode == 200) {
        print(responseId.data['id'].toString());
        var urlStory =
            "https://instagram-best-experience.p.rapidapi.com/stories?user_id="+
                responseId.data['id'].toString();

        final http.Response responseStory =
            await http.get(Uri.parse(urlStory), headers: {
          "X-RapidAPI-Key":
              "1dd2847dccmsh4e6f3a50d4eb9a9p146807jsnbcfe144d7761",
          "X-RapidAPI-Host": "instagram-best-experience.p.rapidapi.com"
        });

        List<dynamic> res = new List<dynamic>.from(json.decode(responseStory.body));
         if (res[0]["error"]) {
           return "Error to fetch username stories. Seems ${_username} does not have recent stories" as List<dynamic>;
         }
       else {
           //parsing data
           List<Map<String, dynamic>> stories = new List<Map<String, dynamic>>.from(json.decode(responseStory.body));
           var data = {};
           data.addAll({
             "username": stories[0]["user"]["username"],
             "is_private": stories[0]["user"]["is_private"],
             "profile_url": stories[0]["user"]["profile_pic_url"],
             "is_verified": stories[0]["user"]["is_verified"],
             "pk": stories[0]["user"]["pk"]
           });
           stories.forEach((element) {
             data = {
               "pk": element["pk"],
               "id": element["id"],
               "media_type": element["media_type"],
               "taken_at": element["taken_at"],
               "expiring_at": element["element_at"],
               ...element["media_type"] == 2
                   ? {
                 "url": element["video_versions"][0]["url"],
                 "width": element["video_versions"][0]["width"],
                 "height": element["video_versions"][0]["height"],
                 "video_duration": element["video_duration"]
               }
                   : {
                 "url": element["image_versions2"]["candidates"][0]["url"],
                 "width": element["image_versions2"]["candidates"][0]["width"],
                 "height": element["image_versions2"]["candidates"][0]["height"]
               },
             };
           });
         }
        if (responseStory.statusCode != 200 || responseId.statusCode != 200) {
          return null;
        }
      } else {
        return "Error to fetch username stories" as List<dynamic>;
      }
      return dataParsed;
  }
}
