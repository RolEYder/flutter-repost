import 'package:flutter/material.dart';
import 'package:repost/api/storiesModel.dart';
import 'package:repost/screens/repost/Screen/repost_schedule_screen.dart';
import 'package:repost/screens/repost/Widget/post.dart';
import 'package:repost/screens/repost/Widget/stories.dart';
import '../../../api/api_servicer.dart';

class RepostScreen extends StatefulWidget {
  const RepostScreen({Key? key}) : super(key: key);

  @override
  State<RepostScreen> createState() => _RepostScreenState();
}

class _RepostScreenState extends State<RepostScreen> {
  final TextEditingController _post = TextEditingController();
  bool ishowPost = false;
  late List<StoriesModel> _storiesModel;
  List<String> STORIES = [];
  List<dynamic> POSTS = [];
  List<String> titleArr = [
    "Rayshean32",
    "alina.sde1",
    "Romiansd22",
    "Sundshade3",
    "Cakior22",
    "Rayshean32",
    "alina.sde1",
    "Romiansd22",
    "Sundshade3",
    "Cakior22"
  ];
  void _getStoriesByUsername(String _username) async {
    //_storiesModel = (await ApiService().getStoriesByUsername(_username));
    //var _stories = await ApiService().getStoriesByUsername(_username);
    var _posts = await ApiService().getPostsByUsername(_username);
    POSTS = _posts as List<dynamic>;
    // for (var i = 0; i < _stories.length; i++) {
    //   if (_stories[i]["thumbnail"] != null) {
    //     STORIES.add(_stories[i]["thumbnail"].toString());
    //     log(_stories[i]["thumbnail"].toString());
    //   }
    // }
  }

  Widget ShowPosts() {
    return new Column(children: <Widget>[
      ...POSTS.map((e) => Posts(
            username: e["username"],
            text: (e["text"].toString() + e["hashtags"].join(" ")),
            thumbnail: e["display_url"].toString(),
            profilepic: e["profile_pic"].toString(),
          ))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, top: 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextField(
                style: const TextStyle(fontSize: 16),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _getStoriesByUsername(value.toString());
                    setState(() {
                      ishowPost = true;
                    });
                  }
                },
                controller: _post,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintStyle: const TextStyle(color: Colors.grey),
                    hintText: "Search",
                    suffixIcon: IconButton(
                      onPressed: _post.clear,
                      icon: Icon(Icons.clear),
                      iconSize: 16,
                      color: Colors.white,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 58, 57, 57),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
            ),
            ishowPost
                ? Expanded(
                    child: Center(
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          const Text(
                            "REPOST STORIES",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Select the user to repost",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          ///Story///
                          Stories(titleArr: titleArr, showPostDetail: true),

                          const Text(
                            "POSTS",
                            style: TextStyle(
                                fontSize: 52,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RepostSchedule()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: ShowPosts(),
                              ))
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Column(
                        children: const [
                          SizedBox(
                            height: 200,
                          ),
                          Text(
                            "Copy the link of the post that you want to repost and re-enter our app so we can automatically detect the content you want to repost. You can also search by username above and select the content you want to Repost.",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
