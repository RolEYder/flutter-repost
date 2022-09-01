// @dart=2.9
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:repost/api/storiesModel.dart';
import 'package:repost/helper/herpers.dart';
import 'package:repost/screens/repost/Screen/repost_schedule_screen.dart';
import 'package:repost/screens/repost/Widget/post.dart';
import 'package:repost/screens/repost/Widget/stories.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../../api/api_servicer.dart';
import '../../../db/db_sqlite_helper.dart';
import '../../../model/searcher-posts.dart';
import '../../../db/db_sqlite_helper.dart' as dbHelper;
class RepostScreen extends StatefulWidget {
  const RepostScreen({Key key}) : super(key: key);
  @override
  State<RepostScreen> createState() => _RepostScreenState();
}
class _RepostScreenState extends State<RepostScreen> {

  final TextEditingController _post = TextEditingController();
  bool _isLoading = false;
  String HEADER = "";
  List<StoriesModel> _storiesModel;
  List<String> STORIES = [];
  List<dynamic> POSTS = [];
  List<dynamic> CLICKED_POSTS  = [];
  List<dynamic> errors = [];
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

  void _getPostByShortCode(String _shortcode) async {
    final _posts  = await ApiService().getPostByShortCode(_shortcode);
    String image = _posts["image"].toString();
    String caption = _posts["caption"].toString();
    String uid = _posts["id"].toString();
    String username = _posts["username"] as String;
    String thumbnailpic = _posts["thumbnailpic"] as String;
    log(_posts.toString());
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
  void _getPostsByUsername(BuildContext context,  _username) async {
    var _posts = await ApiService().getPostsByUsername(_username);
    log(_posts.toString());
    if (_posts[0]["type"] == "error") {
      _getAllClickedPosts();
      _dialogBuilder(context, "Something unexpected occur", _posts[0]["message"] + " of user " + _username.toString());
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
    setState(() {
      HEADER = "RECENT POSTS";
    });
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
                onChanged:(value) {
                  if(value.length == 0) {
                    _getAllClickedPosts();
                   setState(() {
                     HEADER = "RECENT POSTS";
                   });
                  }
                },
                onSubmitted: (value) async {
                  CLICKED_POSTS = [];
                  setState(() {
                    HEADER = "POSTS";
                  });
                  if (value.isNotEmpty) {
                    /// checking if is an username url or username
                    if (hasValidUrlString(value.toString())) {
                           /// if is a post
                            if (isPostUrl(value.toString())) {
                              String shortcode = getShortCodeFromUrl(value.toString());
                              pr.show();
                              Future.delayed(Duration(seconds: 5)).then((value) => {
                                pr.hide().whenComplete(() => {
                                  setState(() {
                                    _getPostByShortCode(shortcode.toString());
                                  })
                                })
                              });
                            }
                            else {
                              /// then, is a username
                              String username = getShortCodeFromUrl(value.toString());
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
                    else if ('${value[0].toString()}' == "@") {
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
                    }
                    else  {
                      _getPostsByUsername(context, value.toString());
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
                    _dialogBuilder(context, "Oops!🤔", "You must enter a proper Instagram username, url post or url username");
                  }
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

                          ///Story///
                          Stories(titleArr: titleArr, showPostDetail: true),


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
                          (CLICKED_POSTS.isEmpty) ?
                          GestureDetector(
                              child: Padding(
                                padding:  EdgeInsets.only(right: 12),
                                child: (POSTS.isNotEmpty) ? showInstagramPosts() : Text("There aren't current clicked posts"),
                              )) :
                            GestureDetector(
                              child: Padding(
                                padding:  EdgeInsets.only(right: 12),
                                child: (CLICKED_POSTS.isNotEmpty) ? showInstagramClickedPosts() : showInstagramPosts(),
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
  Future<void> _dialogBuilder(BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(title.toString()),
          content:  Text(content.toString()),
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
  Future<void> _saveClickedPosts(content, uid, profilepic, thumbnailpic, username) async {
    Map<String, dynamic> row = {DatabaseHelper.columnContentPostsSearches: content,
      DatabaseHelper.columnCodePostSearches: uid, DatabaseHelper.columnProfilePicPostsSearches: profilepic,
      DatabaseHelper.columnThumbnailPicPostsSearches: thumbnailpic,
      DatabaseHelper.columnUsernamePostsSearches: username, DatabaseHelper.columnCreatedAtPostsSearches: DateTime.now().toString()};
    SearchersPosts searchersPosts = SearchersPosts.fromMap(row);
    DatabaseHelper.instance.insert_searcher_post(searchersPosts);
  }
  void _getAllClickedPosts() async {
    final allClickPosts = await dbHelper.DatabaseHelper.instance.getAllSearchersRowsPosts();
    if(allClickPosts.isNotEmpty){
      setState(() {
        CLICKED_POSTS = allClickPosts;
      });
    }
    else {
      setState(() {
        CLICKED_POSTS.add({});
      });
    }
  }
}
