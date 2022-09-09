import 'package:http/http.dart' as http;
import 'package:repost/helper/herpers.dart' as Helpers;

class HashTagService {

  /// Get List of hashtags by category
  /// @_category [String] category hashtag
  Future<List<String>> getListHashTagsByCategory(String _category) async {
    List<String> _hashtags = [];
    final url = "https://instahashtag.p.rapidapi.com/instahashtag?tag=" + _category;
    final http.Response response = await http.get(Uri.parse(url), headers: {
      "X-RapidAPI-Key": "cb42a464cbmsh5d08b3d42135b64p1de875jsn9ef075c0c463",
      "X-RapidAPI-Host": "instahashtag.p.rapidapi.com",
    });
    if (response.statusCode == 200) {
      _hashtags = Helpers.getHashtagsFromString(response.body.toString());
    }
    else {
      _hashtags.add(_category.toString());
    }
    return _hashtags;
  }
}