import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:repost/helper/herpers.dart';

class PostService {
  /// Function to get all a post giving its shortcode
  /// @shortcode [String] post shortcode
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

  /// Function to get all a post giving username
  /// @_username [String] username
  Future<List<dynamic>?> getPostsByUsername(String _username) async {
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
        "X-RapidAPI-Key": "cb42a464cbmsh5d08b3d42135b64p1de875jsn9ef075c0c463",
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
      final profile_pic = await json.decode(profile_pic_res.body);
      print(profile_pic.toString());
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
      print("Unable to load posts");
    }
    return dataParsed;
  }
}
