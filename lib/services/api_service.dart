import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../helper/herpers.dart';

class ApiService {
  /// Function to get posts info  giving a idpost
  Future<List<Map<String, dynamic>>> getInfoPost(String _idpost) async {
    return "hello" as List<Map<String, dynamic>>;
  }

  /// Function to get post giving its shortcode
  Future<Map<String, dynamic>?> getPostByShortCode(String shortcode) async {
    Map<String, dynamic> dataParsed = {};
    var url =
        "https://instagram-scraper-2022.p.rapidapi.com/ig/post_info/?shortcode=" +
            shortcode;
    final http.Response response = await http.get(Uri.parse(url), headers: {
      "X-RapidAPI-Key": "9da44fc6ddmsh37b9e8973436610p10ab16jsnf989eb4c232a",
      "X-RapidAPI-Host": "instagram-scraper-2022.p.rapidapi.com"
    });

    final data = json.decode(response.body);
    dataParsed = {
      "id": data["id"],
      "shortcode": data["shortcode"],
      "image": data["display_resources"][0]["src"],
      "is_video": data["is_video"],
      "caption": data["edge_media_to_caption"]["edges"][0]["node"]["text"],
      "thumbnailpic": data["owner"]["profile_pic_url"],
      "username": data["owner"]["username"],
      "accessibility_caption": data["accessibility_caption"]
    };
    return dataParsed;
  }

  /// Function to get stories giving their usernames
  Future<List<dynamic>?> getPostsByUsername(String _username) async {
    List<dynamic> dataParsed = [];

    //first at all, get the user id by their username
    var url =
        "https://instagram-scraper-2022.p.rapidapi.com/ig/user_id/?user=" +
            _username;
    var dio = Dio();
    //building GET request headers
    dio.options.headers['X-RapidAPI-Key'] =
        "9da44fc6ddmsh37b9e8973436610p10ab16jsnf989eb4c232a";
    dio.options.headers['X-RapidAPI-Host'] =
        "instagram-scraper-2022.p.rapidapi.com";
    dio.options.headers["Cookie"] = "PHPSESSID=bcmf0d1qph5houlg8k8qo3fm1l";
    dio.options.headers["Cache-Control"] = "no-cache";
    dio.options.headers["Accept"] = "*/*";
    dio.options.headers["Accept-Encoding"] = "gzip, deflate, br, json";

    var res = await dio.get(url);
    if (res.statusCode == 200) {
      var post_url =
          "https://instagram-scraper-2022.p.rapidapi.com/ig/posts/?id_user=" +
              res.data['id'].toString();
      final http.Response data_res =
          await http.get(Uri.parse(post_url), headers: {
        "X-RapidAPI-Key": "9da44fc6ddmsh37b9e8973436610p10ab16jsnf989eb4c232a",
        "X-RapidAPI-Host": "instagram-scraper-2022.p.rapidapi.com"
      });

      //getting profile pic
      var url =
          "https://instagram-best-experience.p.rapidapi.com/profile?username=" +
              _username;
      final profile_pic_res = await http.get(Uri.parse(url), headers: {
        "X-RapidAPI-Key": "1dd2847dccmsh4e6f3a50d4eb9a9p146807jsnbcfe144d7761",
        'X-RapidAPI-Host': 'instagram-best-experience.p.rapidapi.com'
      });
      final profile_pic = json.decode(profile_pic_res.body);
      log(data_res.body.toString());
      if (json.decode(data_res.body)["data"] == null) {
        List<dynamic> err = [
          {"type": "error", "message": "Error to fetch Posts"}
        ];
        return err;
      }

      // parsing data
      List<Map<String, dynamic>> posts = List.castFrom(
          json.decode(data_res.body)["data"]["user"]
              ["edge_owner_to_timeline_media"]["edges"]);
      posts.forEach((element) {
        final data = {
          "_typeimage": element["node"]["__typename"].toString(),
          "dimesions": {
            "height": element["node"]["display_resources"][2]["config_height"],
            "width": element["node"]["display_resources"][1]["config_width"]
          },
          "id": element["node"]["id"],
          "display_url":
              element["node"]["display_resources"][0]["src"].toString(),
          "is_video": element["node"]["is_video"],
          "text": (element["node"]["edge_media_to_caption"]["edges"][0] == " "
                  ? " "
                  : element["node"]["edge_media_to_caption"]["edges"][0]["node"]
                      ["text"])
              .toString(),
          "username": element["node"]["owner"]["username"].toString(),
          "hashtags": getHashtagsFromString(element["node"]
                  ["edge_media_to_caption"]["edges"][0]["node"]["text"]
              .toString()),
          "profile_pic": profile_pic["profile_pic_url"].toString()
        };
        dataParsed.add(data);
      });
      if (data_res.statusCode != 200) {
        return null;
      }
    } else {
      log("Unable to load posts");
    }
    return dataParsed;
  }

  // ignore: body_might_complete_normally_nullable
  Future<List<Map<String, dynamic>>?> getStoriesByUserName(
      String _username) async {
    try {
      // getting user id
      var url =
          "https://instagram-scraper-2022.p.rapidapi.com/ig/user_id/?user=" +
              _username;
      final http.Response reponseUserId =
          await http.get(Uri.parse(url), headers: {
        "X-RapidAPI-Key": "9da44fc6ddmsh37b9e8973436610p10ab16jsnf989eb4c232a",
        "X-RapidAPI-Host": "instagram-scraper-2022.p.rapidapi.com"
      });
      final userid = json.decode(reponseUserId.body)["id"];
      // getting stories
      var urlStories =
          "https://instagram-best-experience.p.rapidapi.com/stories?user_id=" +
              userid.toString();
      final http.Response responseStories =
          await http.get(Uri.parse(urlStories), headers: {
        "X-RapidAPI-Key": "1dd2847dccmsh4e6f3a50d4eb9a9p146807jsnbcfe144d7761",
        'X-RapidAPI-Host': 'instagram-best-experience.p.rapidapi.com'
      });

      if (responseStories.statusCode == 200) {
        List<Map<String, dynamic>> stories =
            List.castFrom(json.decode(responseStories.body));
        stories.forEach((element) {
          // final data = {
          //   "pk": element["pk"],
          //   "id": element["id"],
          //   "taken_at": element["taken_at"],
          //   "expiring_at":  element["expiring_at"],
          //   ""
          //
          // };
        });
      }
    } catch (Exception) {
      print(Exception);
    }
  }

  // Future<List<dynamic>> getStoriesByUsername(String _username) async {
  //   try {
  //     //first at all, get the user id by their username
  //     var url_id =
  //         "https://instagram-scraper-2022.p.rapidapi.com/ig/user_id/?user=" +
  //             _username;
  //     var dio = Dio();
  //     dio.options.headers['X-RapidAPI-Key'] =
  //         "9da44fc6ddmsh37b9e8973436610p10ab16jsnf989eb4c232a";
  //     dio.options.headers['X-RapidAPI-Host'] =
  //         "instagram-scraper-2022.p.rapidapi.com";
  //     var url_id_reponse = await dio.get(url_id);
  //     if (url_id_reponse.statusCode == 200) {
  //       var ID_USERNAME = url_id_reponse.data["id"].toString();
  //       // then get stories by username id
  //       var stories_url =
  //           "https://instagram-stories1.p.rapidapi.com/user_stories?userid=" +
  //               ID_USERNAME;
  //       dio.options.headers['X-RapidAPI-Host'] =
  //           "instagram-stories1.p.rapidapi.com";
  //       final reponse = await dio.get(stories_url);
  //       if (reponse.statusCode == 200) {
  //         //log(reponse.data.toString());
  //         return reponse.data["downloadLinks"] as List<dynamic>;
  //       } else {
  //         log("Unable to load stories");
  //       }
  //     } else {
  //       log("Unable to load stories");
  //     }
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  //   throw (e) {
  //     throw Exception('Unexpected error occured!');
  //   };
  // }
}
