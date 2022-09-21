// ignore: unused_element
List<String> getHashtagsFromString(String _text) {
  List<String> _listHashastags = [];
  RegExp exp = new RegExp(r"\B#\w\w+");
  exp.allMatches(_text).forEach((match) {
    _listHashastags.add(match.group(0).toString());
  });
  return _listHashastags;
}

bool hasValidUrlString(String url) {
  String pattern =
      r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
  RegExp regExp = new RegExp(pattern);
  if (url.length == 0) {
    return false;
  } else if (!regExp.hasMatch(url)) {
    return false;
  }
  return true;
}

bool isPostUrl(String _urlPosts) {
  String pattern = r'(?:https?:\/\/www\.)?instagram\.com\S*?\/p\/';
  RegExp regExp = new RegExp(pattern);
  if (_urlPosts.length == 0) {
    return false;
  } else if (!regExp.hasMatch(_urlPosts)) {
    return false;
  }
  return true;
}

bool isStoryUrl(String _urlStory) {
  String pattern = r'(?:https?:\/\/www\.)?instagram\.com\S*?\/stories\/';
  RegExp regExp = new RegExp(pattern);
  if (_urlStory.length == 0) {
    return false;
  } else if (!regExp.hasMatch(_urlStory)) {
    return false;
  }
  return true;
}

bool isReelUrl(String _urlReel) {
  String pattern = r'(?:https?:\/\/www\.)?instagram\.com\S*?\/reel\/';
  RegExp regExp = new RegExp(pattern);
  if (_urlReel.length == 0) {
    return false;
  } else if (!regExp.hasMatch(_urlReel)) {
    return false;
  }
  return true;
}

String getShortCodeFromUrl(String url) {
  String pattern = r'[^/]+(?=/$|$)';
  RegExp regExp = new RegExp(pattern);
  if (url.length == 0) {
    return "none";
  } else if (!regExp.hasMatch(url)) {
    return "none";
  }
  return regExp.stringMatch(url).toString();
}

String getHashtagsFromList(List<String> hashtags, int n) {
  List<String> str = [];
  for (int i = 0; i < n; i++) {
    str.add(hashtags[i]);
  }
  return str.join();
}
