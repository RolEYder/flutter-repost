import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:repost/api/storiesModel.dart';
import 'package:repost/screens/repost/Screen/repost_schedule_screen.dart';
import 'package:repost/screens/repost/Widget/post.dart';
import 'package:repost/screens/repost/Widget/stories.dart';
import 'package:repost/screens/schedule/schedulescreen.dart';
import '../../../api/api_servicer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RepostScreen extends StatefulWidget {
  const RepostScreen({Key? key}) : super(key: key);

  @override
  State<RepostScreen> createState() => _RepostScreenState();
}

class _RepostScreenState extends State<RepostScreen> {
  final TextEditingController _post = TextEditingController();
  bool ishowPost = false;
  bool _isLoading = false;
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
    log(_posts.toString());
    POSTS = _posts as List<dynamic>;
    // for (var i = 0; i < _stories.length; i++) {
    //   if (_stories[i]["thumbnail"] != null) {
    //     STORIES.add(_stories[i]["thumbnail"].toString());
    //     log(_stories[i]["thumbnail"].toString());
    //   }
    // }
  }

  // Widget function to show instagram posts
  Widget showInstagramPosts() {
    return new Column(children: <Widget>[
      ...POSTS.map((e) => Posts(
            username: e["username"],
            text: (e["text"].toString()),
            thumbnail: e["display_url"].toString(),
            profilepic: e["profile_pic"].toString(),
          ))
    ]);
  }

  // Widget _gesturePostsDetector(BuildContext buildContext) {
  //   return new GestureDetector(
  //       onTap: () {
  //         POSTS.map((e) => {
  //               Navigator.push(buildContext,
  //                   MaterialPageRoute<Widget>(builder: (buildContext) {
  //                 try {
  //                   RepostSchedule(
  //                       picprofile: e["display_url"].toString().isEmpty
  //                           ? "/assets/category4.png"
  //                           : e["display_url"].toString());
  //                 } catch (e) {}
  //                 throw (e) {
  //                   log(e.toString());
  //                 };
  //               }))
  //             });
  //       },
  //       child: Padding(
  //         padding: const EdgeInsets.only(right: 12),
  //         child: showInstagramPosts(),
  //       ));
  // }

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
                onSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    _getStoriesByUsername(value.toString());
                    setState(() {
                      _isLoading = true;
                      ishowPost = true;
                    });
                    await Future.delayed(const Duration(seconds: 2));
                    setState(() {
                      _isLoading = false;
                    });
                  } else {
                    Alert(
                            buttons: [
                          DialogButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              "Ok!",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 2),
                            ),
                          )
                        ],
                            context: context,
                            title: "Oops!🤔",
                            desc: "You must enter a proper Instagram username")
                        .show();
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
            !_isLoading
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
                              child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: showInstagramPosts(),
                          ))
                        ],
                      ),
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
