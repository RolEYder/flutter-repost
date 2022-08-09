// ignore: unused_element
List<String> getHashtagsFromString(String _text) {
  List<String> _listHashastags = [];
  RegExp exp = new RegExp(r"\B#\w\w+");
  exp.allMatches(_text).forEach((match) {
    _listHashastags.add(match.group(0).toString());
  });
  return _listHashastags;
}

String getHashtasFromList(List<String> hashtags, int n) {
  List<String> str = [];
  for (int i = 0; i < n; i++) {
    str.add(hashtags[i]);
  }
  return str.join();
}
