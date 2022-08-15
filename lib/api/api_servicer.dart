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
        "X-RapidAPI-Key": "9da44fc6ddmsh37b9e8973436610p10ab16jsnf989eb4c232a",
        'X-RapidAPI-Host': 'instagram-best-experience.p.rapidapi.com'
      });
      final profile_pic = json.decode(profile_pic_res.body);
      log(data_res.body.toString());
      if (json.decode(data_res.body)["data"] == null) {
        List<dynamic> err = [
          {"type": "error", "message": "Error to fecth Posts"}
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
      // log(dataParsed.toString());

      //final postdata = List<Map<String, dynamic>>.from(jsonDecode(data_res.body));
    } else {
      log("Unable to load posts");
    }
    return dataParsed;
  }

  Future<List<dynamic>> getStoriesByUsername(String _username) async {
    try {
      //first at all, get the user id by their username
      var url_id =
          "https://instagram-scraper-2022.p.rapidapi.com/ig/user_id/?user=" +
              _username;
      var dio = Dio();
      dio.options.headers['X-RapidAPI-Key'] =
          "9da44fc6ddmsh37b9e8973436610p10ab16jsnf989eb4c232a";
      dio.options.headers['X-RapidAPI-Host'] =
          "instagram-scraper-2022.p.rapidapi.com";
      var url_id_reponse = await dio.get(url_id);
      if (url_id_reponse.statusCode == 200) {
        var ID_USERNAME = url_id_reponse.data["id"].toString();
        // then get stories by username id
        var stories_url =
            "https://instagram-stories1.p.rapidapi.com/user_stories?userid=" +
                ID_USERNAME;
        dio.options.headers['X-RapidAPI-Host'] =
            "instagram-stories1.p.rapidapi.com";
        final reponse = await dio.get(stories_url);
        if (reponse.statusCode == 200) {
          //log(reponse.data.toString());
          return reponse.data["downloadLinks"] as List<dynamic>;
        } else {
          log("Unable to load stories");
        }
      } else {
        log("Unable to load stories");
      }
    } catch (e) {
      throw Exception(e);
    }
    throw (e) {
      throw Exception('Unexpected error occured!');
    };
  }
}
