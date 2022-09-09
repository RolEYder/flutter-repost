// @dart=2.9

import 'package:flutter/material.dart';
import 'package:repost/helper/herpers.dart';
import 'package:repost/screens/repost/Screen/repost_schedule_screen.dart';
import 'package:repost/screens/repost/Widget/post.dart';
import 'package:repost/screens/repost/Widget/stories.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:repost/services/story_service.dart';
import 'package:repost/services/posts_service.dart';

import 'package:repost/services/database_service.dart';
import 'package:repost/models/searcherPost_model.dart';
import 'package:repost/services/database_service.dart' as dbHelper;

import 'package:repost/models/story_model.dart';

import 'package:repost/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepostScreen extends StatefulWidget {
  const RepostScreen({Key key}) : super(key: key);
  @override
  State<RepostScreen> createState() => _RepostScreenState();
}

class _RepostScreenState extends State<RepostScreen> {
  final TextEditingController _post = TextEditingController();
  bool _isLoading = false;
  String HEADER = "";
  List<String> STORIES = [];
  List<dynamic> POSTS = [];
  List<dynamic> CLICKED_POSTS = [];
  List<dynamic> errors = [];
  List<Story> _STORIES = [];
  List<String> titleArr = [];

  void _getPostByShortCode(String _shortcode) async {
    final _posts = await PostService().getPostByShortCode(_shortcode);
    String image = _posts["image"].toString();
    String caption = _posts["caption"].toString();
    String uid = _posts["id"].toString();
    String username = _posts["username"] as String;
    String thumbnailpic = _posts["thumbnailpic"] as String;
    //save posts
    _saveClickedPosts(caption, uid, image, thumbnailpic, username);
    // open up Reposts schedule
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => RepostSchedule(
                  picprofile: image,
                  CustomCaption: caption,
                  uid: uid,
                  username: username,
                ))));
  }

  void _getStoriesByUsername(BuildContext context, _username) async {
    _STORIES = [];
    var _stories = await StoryService().getStoriesByUserUsername(_username);
    if (_stories.isEmpty) {
      _dialogBuilder(context, "Something unexpected occur",
          "Error to fetch stories username, please try again!");
    } else {
      final User user = User(
          name: _stories[0]["username"].toString(),
          profileImageUrl: _stories[0]["profile_url"].toString());
      for (var element = 1; element < _stories.length; element++) {
        _STORIES.add(Story(
            url: _stories[element]["url"],
            media: (_stories[element]["media_type"] == 1
                ? MediaType.image
                : MediaType.video),
            duration: (_stories[element]["media_type"] == 2)
                ? Duration(seconds: 0)
                : Duration(
                    seconds: _stories[element]["video_duration"] == null
                        ? 5
                        : _stories[element]["video_duration"]),
            user: user));
      }
    }
  }

  void _getPostsByUsername(BuildContext context, _username) async {
    var _posts = await PostService().getPostsByUsername(_username);
    if (_posts[0]["type"] == "error") {
      _getAllClickedPosts();
      _dialogBuilder(context, "Something unexpected occur",
          _posts[0]["message"] + " of user " + _username.toString());
    } else {
      setState(() {
        POSTS = _posts;
      });
    }
  }

  // Widget function to show instagram posts
  Widget showInstagramPosts() {
    return new GestureDetector(
        child: Column(children: <Widget>[
      ...POSTS.map((e) => Posts(
            uid: e["id"].toString(),
            username: e["username"],
            text: (e["text"].toString()),
            thumbnail: e["display_url"].toString(),
            profilePic: e["profile_pic"].toString(),
          ))
    ]));
  }

  Widget showInstagramClickedPosts() {
    return new GestureDetector(
        child: Column(children: <Widget>[
      ...CLICKED_POSTS.map((e) => Posts(
            uid: e["uid"],
            username: e["username"],
            text: (e["content"].toString()),
            thumbnail: e["thumbnailpic"].toString(),
            profilePic: e["profilepic"].toString(),
          ))
    ]));
  }

  @override
  void initState() {
    super.initState();
    _getAllClickedPosts();
  }

  Widget build(BuildContext context) {
    ProgressDialog pr = new ProgressDialog(context);
    pr.style(message: 'Please wait...');
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
                onChanged: (value) async {
                  if (value.length == 0) {
                    POSTS.clear();
                    final prefs = await SharedPreferences.getInstance();
                    var areThereClickedPosts = prefs.getString('clicked');
                    if (areThereClickedPosts.toString() == "true") {
                      _getAllClickedPosts();
                    }
                    setState(() {
                      HEADER = "RECENT POSTS";
                    });
                  }
                },
                onSubmitted: (inputValue) async {
                  CLICKED_POSTS = [];
                  titleArr.clear();
                  titleArr.add(inputValue);
                  setState(() {
                    HEADER = "POSTS";
                  });
                  if (inputValue.isNotEmpty) {
                    /// checking if is an username url or username
                    if (hasValidUrlString(inputValue.toString())) {
                      inputValue =
                          inputValue.substring(0, inputValue.length - 1);

                      /// if is a post
                      if (isPostUrl(inputValue.toString())) {
                        String shortcode =
                            getShortCodeFromUrl(inputValue.toString());
                        pr.show();
                        Future.delayed(Duration(seconds: 5)).then((value) => {
                              pr.hide().whenComplete(() => {
                                    setState(() {
                                      _getPostByShortCode(shortcode.toString());
                                    })
                                  })
                            });
                      } else {
                        /// then, is a username
                        String username =
                            getShortCodeFromUrl(inputValue.toString());
                        _getPostsByUsername(context, username);
                        pr.show();
                        Future.delayed(Duration(seconds: 10)).then((value) => {
                              pr.hide().whenComplete(() => {
                                    setState(() {
                                      _isLoading = false;
                                    })
                                  })
                            });
                        setState(() {
                          _isLoading = true;
                        });
                      }
                    }
                    // if is a username
                    else if ('${inputValue[0].toString()}' == "@") {
                      _getPostsByUsername(context, toString().substring(1));
                      Future.delayed(Duration(seconds: 10)).then((value) => {
                            pr.hide().whenComplete(() => {
                                  setState(() {
                                    _isLoading = false;
                                  })
                                })
                          });
                      setState(() {
                        _isLoading = true;
                      });
                    } else {
                      _getPostsByUsername(context, inputValue.toString());
                      pr.show();
                      Future.delayed(Duration(seconds: 10)).then((value) => {
                            pr.hide().whenComplete(() => {
                                  setState(() {
                                    _isLoading = false;
                                  })
                                })
                          });
                      setState(() {
                        _isLoading = true;
                      });
                    }
                  } else {
                    setState(() {
                      _getAllClickedPosts();
                      HEADER = "RECENT POSTS";
                    });
                    _dialogBuilder(context, "Oops!🤔",
                        "You must enter a proper Instagram username, url post or url username");
                  }
                  // testing stories
                  _getStoriesByUsername(context, inputValue.toString());
                },
                controller: _post,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintStyle: const TextStyle(color: Colors.grey),
                    hintText: "Enter Instagram username or post url",
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
                          Stories(
                            titleArr: titleArr,
                            showPostDetail: true,
                            stories: _STORIES,
                          ),
                          Text(
                            HEADER.toString(),
                            style: TextStyle(
                                fontSize: 52,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          (CLICKED_POSTS.isEmpty)
                              ? GestureDetector(
                                  child: Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: (POSTS.isNotEmpty)
                                      ? showInstagramPosts()
                                      : Text(
                                          "There aren't current clicked posts",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                ))
                              : GestureDetector(
                                  child: Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: (CLICKED_POSTS.isNotEmpty)
                                      ? showInstagramClickedPosts()
                                      : showInstagramPosts(),
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

  Future<void> _dialogBuilder(
      BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title.toString()),
          content: Text(content.toString()),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //save clicked posts
  Future<void> _saveClickedPosts(
      content, uid, profilepic, thumbnailpic, username) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnContentPostsSearches: content,
      DatabaseHelper.columnCodePostSearches: uid,
      DatabaseHelper.columnProfilePicPostsSearches: profilepic,
      DatabaseHelper.columnThumbnailPicPostsSearches: thumbnailpic,
      DatabaseHelper.columnUsernamePostsSearches: username,
      DatabaseHelper.columnCreatedAtPostsSearches: DateTime.now().toString()
    };
    SearchersPosts searchersPosts = SearchersPosts.fromMap(row);
    DatabaseHelper.instance.insert_searcher_post(searchersPosts);
  }

  void _getAllClickedPosts() async {
    final allClickPosts =
        await dbHelper.DatabaseHelper.instance.getAllSearchersRowsPosts();
    final prefs = await SharedPreferences.getInstance();
    if (allClickPosts.isNotEmpty) {
      prefs.setString('clicked', "true");
      setState(() {
        CLICKED_POSTS = allClickPosts;
        HEADER = "RECENT POSTS";
      });
    } else {
      setState(() {
        prefs.setString('clicked', "false");
      });
    }
  }
}
