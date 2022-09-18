import 'dart:convert';
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
    var responseId = await dio.get(url);
    if (responseId.statusCode == 200) {
      var urlStory = "https://instagram188.p.rapidapi.com/userstories/" +
          responseId.data['id'].toString();

      final http.Response responseStory =
          await http.get(Uri.parse(urlStory), headers: {
        "X-RapidAPI-Key": "cb42a464cbmsh5d08b3d42135b64p1de875jsn9ef075c0c463",
        "X-RapidAPI-Host": "instagram188.p.rapidapi.com"
      });
      if (json.decode(responseStory.body)["success"] == false) {
        return List<dynamic>.from({
          {
            "Error":
                "Error to fetch username stories. Seems ${_username} does not have recent stories"
          }
        });
      } else {
        List<dynamic> stories =
            List<dynamic>.from(json.decode(responseStory.body)["data"]);
        //parsing data
        var data = {};

        data.addAll({
          "username": stories[0]["user"]["username"],
          "is_private": stories[0]["user"]["is_private"],
          "profile_url": stories[0]["user"]["profile_pic_url"],
          "is_verified": stories[0]["user"]["is_verified"],
          "pk": stories[0]["user"]["pk"]
        });
        dataParsed.add(data);
        stories.forEach((element) {
          data = {
            "pk": element["pk"],
            "id": element["id"],
            "media_type": element["media_type"],
            "taken_at": element["taken_at"],
            "device_timestamp": element["device_timestamp"],
            ...element["media_type"] == 2
                ? {
                    "video_coded": element["video_codec"],
                    "url": element["video_versions"][0]["url"],
                    "width": element["video_versions"][0]["width"],
                    "height": element["video_versions"][0]["height"],
                    "video_duration": element["video_duration"]
                  }
                : {
                    "url": element["image_versions2"]["candidates"][0]["url"],
                    "width": element["image_versions2"]["candidates"][0]
                        ["width"],
                    "height": element["image_versions2"]["candidates"][0]
                        ["height"]
                  },
          };
          dataParsed.add(data);
        });
      }
      if (responseStory.statusCode != 200 || responseId.statusCode != 200) {
        return null;
      }
    } else {
      throw Exception("Error to fetch username stories");
    }
    return dataParsed;
  }
}
