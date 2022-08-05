import 'dart:developer';
import 'package:dio/dio.dart';

class ApiService 
  /// Fnction to get posts info  giving a idpost
  Future<List<dynamic>> getInfoPost(String _idpost) async {
  
  }
  /// Fction to get stories giving their usernames
  Future<List<dynamic>> getPostsByUsername(String _username) async {
    try {
      //first at all, get the user id by their username
      var url =
          "https://instagram-scraper-2022.p.rapidapi.com/ig/user_id/?user=" +
              _username;
      var dio = Dio();
      dio.options.headers['X-RapidAPI-Key'] =
          "9da44fc6ddmsh37b9e8973436610p10ab16jsnf989eb4c232a";
      dio.options.headers['X-RapidAPI-Host'] =
          "instagram-scraper-2022.p.rapidapi.com";
      var res = await dio.get(url);
      if (res.statusCode == 200) {
        var post_url =
            "https://instagram-scraper-2022.p.rapidapi.com/ig/posts/?id_user=391755178";
        var data_res = await dio.get(post_url);
        if (data_res.statusCode == 200) {
          return data_res.data["user"] as List<dynamic>;
        } else {
          log("Unable to load posts");
        }
      } else {
        log("Unable to load posts");
      }
    } catch (err) {
      log(err.toString());
    }
    throw (e) {
      throw Exception(e);
    };
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
      log(e.toString());
    }
    throw (e) {
      throw Exception("Error to load data");
    };
  }
}
