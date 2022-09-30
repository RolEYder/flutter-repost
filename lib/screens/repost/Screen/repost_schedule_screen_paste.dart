import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart' as cachedVideo;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:instagram_video_story_share/instagram_video_story_share.dart';
import 'package:repost/helper/herpers.dart';
import 'package:repost/screens/pro/proscreen.dart';
import 'package:repost/screens/repost/Screen/repost_hastags_screen.dart';
import 'package:repost/screens/repost/Widget/rate_us.dart';
import 'package:repost/screens/schedule/notify_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:share_plus/share_plus.dart';
import 'caption_screen.dart';
import 'dart:async';
import 'package:share_extend/share_extend.dart';

import 'dart:io' as File;

// REPOSTS SCHEDULE
class RepostSchedulePasted extends StatefulWidget {
  final String profile_pic_url;
  final String caption;
  final String uid;
  final String username;
  final bool is_video;
  final String display_url;
  final List<Map<String, dynamic>> content;

  const RepostSchedulePasted(
      {Key? key,
      required this.is_video,
      required this.content,
      required this.profile_pic_url,
      required this.caption,
      required this.uid,
      required this.display_url,
      required this.username})
      : super(key: key);

  @override
  State<RepostSchedulePasted> createState() => _RepostSchedulePastedState();
}

class _RepostSchedulePastedState extends State<RepostSchedulePasted> {
  TextStyle button = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final _controller = PageController(initialPage: 0);
  String selectedWatermark = "Top left";
  int pageIndex = 0;
  List<dynamic> _captionSelected = [];
  // ignore: unused_field
  List<dynamic> _hashtagSelected = List.empty();
  // ignore: unused_field
  String _scheduleSelected = "";
  // ignore: unused_field
  String _hashtagsSelected = "";
  int selectedAlignment = 0;
  int currentIndexImage = 0;
  bool isShowWaterMark = false;
  late cachedVideo.CachedVideoPlayerController videoController;
  List watermarks = [
    "Top Left",
    "Top Right",
    "Bottom Left",
    "Bottom Right",
  ];
  List alignmentArr = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomLeft,
    Alignment.bottomRight,
  ];

  Widget waterMarks(String title, String trailing) {
    return Container(
      height: 40,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Row(
            children: [
              Text(
                trailing,
                style: const TextStyle(color: Colors.grey),
              ),
              const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    if (widget.is_video) {
      final File.File file = File.File(widget.content[0]["video_url"]);
      setState(() {
        videoController = cachedVideo.CachedVideoPlayerController.file(file);
      });
      videoController.initialize().then((value) {
        videoController.play();
        setState(() {});
      });
    }
    super.initState();
  }

  void dispose() {
    if (videoController.value.isInitialized) {
      videoController.dispose();
    }
    PaintingBinding.instance.imageCache.clear();
    DefaultCacheManager manager = new DefaultCacheManager();
    manager.emptyCache();
    super.dispose();
  }

  void ShareToStoryOrPost(
      BuildContext context, String pathContent, String Caption) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          const SizedBox(
            height: 25,
            width: 20,
          ),
          Center(
            child: Text("Select option",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            height: 25,
            width: 20,
          ),
          Center(
            child: Text(
              "How do you want to post it on instagram?",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () async {
                    List<String> images = [];
                    for (var i = 0; i < widget.content.length; i++) {
                      var uriImage = widget.content[i]["display_url_image"];

                      images.add(uriImage);
                    }
                    await ShareExtend.shareMultiple(images, "image",
                        subject: widget.caption);
                    // await Share.shareFiles([path],
                    //     text: widget.caption);
                    Navigator.pop(context);
                  },
                  child: Text('Story'),
                  style: TextButton.styleFrom(
                      alignment: Alignment.center, elevation: 0),
                ),
                TextButton(
                  onPressed: () async {
                    var urlImage =
                        widget.content[currentIndexImage]["display_url_image"];

                    await Share.shareFiles([urlImage], text: widget.caption);
                    Navigator.pop(context);
                  },
                  child: Text('Post'),
                  style: TextButton.styleFrom(
                      alignment: Alignment.center, elevation: 0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/back.png")),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "Repost",
          style: button,
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: 450,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                        onPageChanged: (index) {
                          setState(() {
                            index = pageIndex.toInt();
                            currentIndexImage = pageIndex.toInt();
                          });
                        },
                        controller: _controller,
                        itemCount:
                            widget.content.isEmpty ? 1 : widget.content.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              (widget.is_video)
                                  ? videoController.value.isInitialized
                                      ? AspectRatio(
                                          aspectRatio:
                                              videoController.value.aspectRatio,
                                          child: Container(
                                              width: 100,
                                              height: 100,
                                              child:
                                                  cachedVideo.CachedVideoPlayer(
                                                      videoController)))
                                      : const CircularProgressIndicator()
                                  : SizedBox.shrink(),
                              (!widget.is_video &
                                      widget.content.isEmpty &
                                      !(widget.content.contains("video_url"))
                                  ? Container(
                                      decoration: new BoxDecoration(
                                          image: new DecorationImage(
                                              image: AssetImage(
                                                  widget.display_url))),
                                    )
                                  : (widget.is_video)
                                      ? (widget.is_video)
                                          ? videoController.value.isInitialized
                                              ? AspectRatio(
                                                  aspectRatio: videoController
                                                      .value.aspectRatio,
                                                  child: Container(
                                                      width: 100,
                                                      height: 100,
                                                      child: cachedVideo
                                                          .CachedVideoPlayer(
                                                              videoController)))
                                              : const CircularProgressIndicator()
                                          : SizedBox.shrink()
                                      : Container(
                                          decoration: new BoxDecoration(
                                              image: new DecorationImage(
                                                  image: widget.content[index][
                                                              "display_url_image"] !=
                                                          null
                                                      ? AssetImage(widget
                                                              .content[index]
                                                          ["display_url_image"])
                                                      : AssetImage(
                                                          widget.display_url))),
                                        )),
                              if (selectedAlignment >= 0) ...[
                                Align(
                                  alignment: alignmentArr[selectedAlignment],
                                  child: Image.asset(
                                    "assets/watermark_img.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedAlignment = -1;
                                      });
                                    },
                                    child: Text(
                                      "Deactivate Watermark",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ]
                            ],
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SmoothPageIndicator(
                      effect: const WormEffect(dotHeight: 8, dotWidth: 8),
                      controller: _controller,
                      count: widget.content.isEmpty ? 1 : widget.content.length)
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Wrap(
                            children: [
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    selectedAlignment = 0;
                                  });
                                  Navigator.pop(context);
                                },
                                title: Text('Top Left'),
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    selectedAlignment = 1;
                                  });
                                  Navigator.pop(context);
                                },
                                title: Text('Top Right'),
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    selectedAlignment = 2;
                                  });
                                  Navigator.pop(context);
                                },
                                title: Text('Buttom Left'),
                              ),
                              ListTile(
                                onTap: () {
                                  setState(() {
                                    selectedAlignment = 3;
                                  });
                                  Navigator.pop(context);
                                },
                                title: Text('Buttom Right'),
                              ),
                              ListTile(
                                onTap: () async {
                                  final active = await hasActiveSubscription();
                                  if (!active) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProScreen()));
                                  } else {
                                    setState(() {
                                      selectedAlignment = -1;
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                title: Text('None'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: waterMarks(
                          "Watermark",
                          (selectedAlignment >= 0)
                              ? watermarks[selectedAlignment]
                              : "None")),
                  Divider(
                    color: Colors.grey,
                  ),
                  GestureDetector(
                      onTap: () {
                        reteApplication(context);
                        _gettingCaptionAfterSelected(context);
                      },
                      child: waterMarks("Caption",
                          (_captionSelected.isNotEmpty) ? "Selected" : "")),
                  const Divider(
                    color: Colors.grey,
                  ),
                  GestureDetector(
                      onTap: () async {
                        reteApplication(context);
                        _gettingHashtagsAfterSelected(context);
                      },
                      child: waterMarks("Hashtags", "")),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 125, 64, 121)),
                            onPressed: () async {
                              reteApplication(context);
                              final active = await hasActiveSubscription();
                              if (!active) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProScreen()));
                              } else {
                                _gettingScheduleAfterSelected(context);
                              }
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Schedule",
                                    style: button,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.access_time_filled_sharp)
                                ])),
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: SizedBox(
                        height: 45,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 73, 65, 125)),
                            onPressed: () {
                              if (_captionSelected.isEmpty) {
                                _dialogBuilder(context, "Oops!",
                                    "You must select a caption");
                              } else if (!widget.is_video &
                                  !widget.content.isEmpty) {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Wrap(
                                    children: [
                                      const SizedBox(
                                        height: 25,
                                        width: 20,
                                      ),
                                      Center(
                                        child: Text("Select media",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(
                                        height: 25,
                                        width: 20,
                                      ),
                                      Center(
                                        child: Text(
                                          "This post contains multiple files. Do you want to repost all of them or only the selected one?",
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                List<String> images = [];
                                                for (var i = 0;
                                                    i < widget.content.length;
                                                    i++) {
                                                  var uriImage =
                                                      widget.content[i]
                                                          ["display_url_image"];

                                                  images.add(uriImage);
                                                }
                                                await ShareExtend.shareMultiple(
                                                    images, "image",
                                                    subject: widget.caption);
                                                // await Share.shareFiles([path],
                                                //     text: widget.caption);
                                                Navigator.pop(context);
                                              },
                                              child: Text('All media'),
                                              style: TextButton.styleFrom(
                                                  alignment: Alignment.center,
                                                  elevation: 0),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                var urlImage = widget.content[
                                                        currentIndexImage]
                                                    ["display_url_image"];

                                                await Share.shareFiles(
                                                    [urlImage],
                                                    text: widget.caption);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Current photo'),
                                              style: TextButton.styleFrom(
                                                  alignment: Alignment.center,
                                                  elevation: 0),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                String path = widget.content[0]["video_url"];
                                share_video(path);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Repost ",
                                  style: button,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(Icons.send)
                              ],
                            )),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> share_video(String path) async {
    bool result = await InstagramVideoStoryShare.share(videoPath: path);
    return result;
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

  Future<void> _gettingScheduleAfterSelected(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ScheduleRepost()));
    if (!mounted) return;
    setState(() {
      _scheduleSelected = result.toString();
    });
    print(result.toString());
  }

  Future<void> _gettingHashtagsAfterSelected(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => RepostHastags()));
    if (!mounted) return;
    setState(() {
      _hashtagSelected = result;
    });
  }

  Future<void> _gettingCaptionAfterSelected(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Caption(
                CustomCaption: widget.caption.toString(),
                username: widget.username.toString(),
                OriginalCaption: widget.caption.toString())));

    if (!mounted) return;
    setState(() {
      _captionSelected.add({
        "id": result["id"].toString(),
        "title": result["title"].toString(),
        "content": result["content"].toString()
      });
    });
  }
}
