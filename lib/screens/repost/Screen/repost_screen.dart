// @dart=2.9

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:repost/helper/herpers.dart';
import 'package:repost/models/content_model.dart';
import 'package:repost/screens/repost/Widget/post_paste.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:repost/services/posts_service.dart';

import 'package:repost/services/database_service.dart';
import 'package:repost/services/database_service.dart' as dbHelper;
import 'package:fluttertoast/fluttertoast.dart';

class RepostScreen extends StatefulWidget {
  const RepostScreen({Key key}) : super(key: key);
  @override
  State<RepostScreen> createState() => _RepostScreenState();
}

class _RepostScreenState extends State<RepostScreen> {
  bool _isLoading = false;
  List<String> STORIES = [];
  List<dynamic> POSTS = [];
  Map<String, dynamic> PASTED = {};
  List<dynamic> SAVE_DATA = [];
  String _valueSearch = "";
  String _typeSearch = "";

  Widget showInstagramPostsPasted() {
    return Column(children: <Widget>[
      PostPasted(
          uid: PASTED["id"].toString(),
          username: PASTED["username"],
          caption: PASTED["caption"],
          display_url: PASTED["display_url"],
          content: PASTED["content"],
          is_video: PASTED["is_video"],
          profile_pic_url: PASTED["profile_pic_url"]),
    ]);
  }

  /// show saved data
  ///
  List<Map<String, dynamic>> getVideoContet(int index) {
    //print(SAVE_DATA[index]["content"][4]);
    print(jsonDecode(SAVE_DATA[index]["content"])[0]["video_url"]);
    List<Map<String, dynamic>> content = [];
    content.add({
      "has_audio": jsonDecode(SAVE_DATA[index]["content"])[0]["has_audio"],
      "video_url": jsonDecode(SAVE_DATA[index]["content"])[0]["video_url"]
    });
    return content;
  }

  List<Map<String, dynamic>> getContent(int index) {
    List<Map<String, dynamic>> content = [];

    if (jsonDecode(SAVE_DATA[index]["content"]).isNotEmpty) {
      for (var i = 0; i < jsonDecode(SAVE_DATA[index]["content"]).length; i++) {
        content.add({
          "typeimage": jsonDecode(SAVE_DATA[index]["content"])[i]["typeimage"],
          "id": jsonDecode(SAVE_DATA[index]["content"])[i]["id"],
          "display_url_image": jsonDecode(SAVE_DATA[index]["content"])[i]
              ["display_url_image"]
        });
      }
    } else {
      content = new List<Map<String, dynamic>>.empty();
    }

    return content;
  }

  Widget showArchiveContent() {
    var counter = 0;
    return new GestureDetector(
        child: Column(children: <Widget>[
      ...SAVE_DATA.map((e) => PostPasted(
          uid: e["uid"].toString(),
          username: e["username"].toString(),
          caption: e["caption"].toString(),
          display_url: e["display_url"].toString(),
          content: e["is_video"] == 1
              ? getVideoContet(counter++)
              : getContent(counter++),
          is_video: e["is_video"] == 1 ? true : false,
          profile_pic_url: e["profile_pic_url"]))
    ]));
  }

  FToast ftoast;
  @override
  void initState() {
    super.initState();
    ftoast = FToast();
    ftoast.init(context);
    getAllArchiveContent();
    getClipboardPastedLinks();
  }

  showToast(String desc) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.copy,
            color: Colors.white,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            desc,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    ftoast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void getClipboardPastedLinks() async {
    ClipboardData data = await Clipboard.getData(Clipboard.kTextPlain);
    if (hasValidUrlString(data.text)) {
      var url = data.text;
      // post
      if (isPostUrl(url)) {
        showToast("Repost posted from Instagram");
        var pattern = "\/p\/(.*?)\/";
        RegExp regExp = RegExp(pattern);
        if (regExp.hasMatch(url)) {
          var value = regExp.firstMatch(url)?.group(1);
          var _post = await PostService().getPostPasted(value);
          String shortcode = _post["shortcode"].toString();
          String uid = _post["uid"].toString();
          int is_video = _post["is_video"] ? 1 : 0;
          String caption = _post["caption"].toString();
          String profile_pic_url = _post["profile_pic_url"].toString();
          String username = _post["username"].toString();
          String display_url = _post["display_url"].toString();
          int is_verified = _post["is_verified"] ? 1 : 0;
          String accessibility_caption =
              _post["accessibility_caption"].toString();
          List<Map<String, dynamic>> content = [];

          print(_post["content"].isNotEmpty);
          if (_post["content"].isNotEmpty) {
            content = _post["content"];
          } else {
            content = new List<Map<String, dynamic>>.empty();
          }
          saveArchived(
              shortcode,
              uid,
              is_video,
              caption,
              profile_pic_url,
              username,
              display_url,
              is_verified,
              accessibility_caption,
              content);
          setState(() {
            PASTED.addAll(_post);
            _valueSearch = value;
            _typeSearch = "post";
            _isLoading = true;
          });

          Future.delayed(Duration(seconds: 5)).then((value) => {
                setState(() {
                  _isLoading = false;
                })
              });
        }
      }
      // story
      else if (isStoryUrl(data.text)) {
        var storyPattern =
            r'(?:https?:\/\/)?(?:www.)?instagram.com\/?([stories]+)?\/([a-zA-Z0-9\-\_\.]+)\/?([0-9]+)?';
        RegExp regExp = RegExp(storyPattern);
        if (regExp.hasMatch(url)) {
          var value = regExp.firstMatch(url)?.group(3);
          print(value);
          setState(() {
            _valueSearch = value;
            _typeSearch = "story";
          });
        }
      }
      // rell
      else if (isReelUrl(data.text)) {
        showToast("Reel posted from Instagram");
        var pattern = "\/reel\/(.*?)\/";
        RegExp regExp = RegExp(pattern);
        if (regExp.hasMatch(url)) {
          var value = regExp.firstMatch(url)?.group(1);
          var _reel = await PostService().getReelPasted(value);
          String shortcode = _reel["shortcode"].toString();
          String uid = _reel["uid"].toString();
          int is_video = _reel["is_video"] ? 1 : 0;
          String caption = _reel["caption"].toString();
          String profile_pic_url = _reel["profile_pic_url"].toString();
          String username = _reel["username"].toString();
          String display_url = _reel["display_url"].toString();
          int is_verified = _reel["is_verified"] ? 1 : 0;
          String accessibility_caption =
              _reel["accessibility_caption"].toString();
          List<Map<String, dynamic>> content = [];
          if (_reel["content"].isNotEmpty) {
            content = _reel["content"];
          } else {
            content = new List<Map<String, dynamic>>.empty();
          }
          saveArchived(
              shortcode,
              uid,
              is_video,
              caption,
              profile_pic_url,
              username,
              display_url,
              is_verified,
              accessibility_caption,
              content);
          setState(() {
            PASTED.addAll(_reel);
            _valueSearch = value;
            _typeSearch = "reel";
            _isLoading = true;
          });
          Future.delayed(Duration(seconds: 5)).then((value) => {
                setState(() {
                  _isLoading = false;
                })
              });
        }
      }
    }
    Future.delayed(Duration(seconds: 3))
        .then((value) => {showArchiveContent()});
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
            Expanded(
              child: Center(
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    PASTED.isNotEmpty
                        ? GestureDetector(
                            child: Column(
                              children: <Widget>[
                                const Text(
                                  "Current Pasted",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(right: 12),
                                    child: showInstagramPostsPasted())
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Active",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SAVE_DATA.isNotEmpty
                        ? showArchiveContent()
                        : Text("There are not archive content yet."),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Reposted",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// save archived
  Future<void> saveArchived(
      shortcode,
      uid,
      is_video,
      caption,
      profile_pic_url,
      username,
      display_url,
      is_verified,
      accessibility_caption,
      content) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnArchivedShortcode: shortcode,
      DatabaseHelper.columnArchivedUid: uid,
      DatabaseHelper.columnArchivedIsVideo: is_video,
      DatabaseHelper.columnArchivedCaption: caption,
      DatabaseHelper.columnArchivedProfilePicUrl: profile_pic_url,
      DatabaseHelper.columnArchivedUsername: username,
      DatabaseHelper.columnArchivedDisplayUrl: display_url,
      DatabaseHelper.columnArchivedIsVerified: is_verified,
      DatabaseHelper.columnArchivedAccessibilityCaption: accessibility_caption,
      DatabaseHelper.columnArchivedContent: content
    };
    Archived archived = Archived.fromMap(row);
    DatabaseHelper.instance.insert_archived(archived);
  }

  /// getting archived
  void getAllArchiveContent() async {
    final response =
        await dbHelper.DatabaseHelper.instance.get_all_archived_rows();
    if (response.isNotEmpty) {
      setState(() {
        SAVE_DATA = response;
      });
    }
  }
}
