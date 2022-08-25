import 'package:flutter/material.dart';
import 'package:repost/screens/repost/Screen/repost_hastags.dart';
import 'package:repost/screens/schedule/notify_screen.dart';
import 'package:repost/screens/watermark/watermark.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'caption.dart';
import '../../../model/schedule-post.dart';
import '../../../db/db_sqlite_helper.dart';
import 'dart:developer';

// REPOSTS SCHEDULE
class RepostSchedule extends StatefulWidget {
  final String picprofile;
  final String CustomCaption;

  const RepostSchedule(
      {Key? key, required this.picprofile, required this.CustomCaption})
      : super(key: key);

  @override
  State<RepostSchedule> createState() => _RepostScheduleState();
}

class _RepostScheduleState extends State<RepostSchedule> {
  TextStyle button = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  final _controller = PageController(initialPage: 0);
  String selectedWatermark = "off";
  int pageIndex = 0;
  List<dynamic>_captionSelected = [];
  List<dynamic> _hashtagSelected = [];
  DateTime _scheduleSelected = DateTime.now();

  List image = ["smallgirl.png", "smallgirl.png", "smallgirl.png"];
  List watermarks = ["Top Left", "Top Right", "Bottom Left", "Bottom Right"];

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
                          });
                        },
                        controller: _controller,
                        itemCount: image.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Image.network(
                              widget.picprofile.toString(),
                              fit: BoxFit.fill,
                            ),
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SmoothPageIndicator(
                      effect: const WormEffect(dotHeight: 8, dotWidth: 8),
                      controller: _controller,
                      count: image.length)
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        var resp = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Watermark()));

                        if (resp != null) {
                          setState(() {
                            selectedWatermark =
                                resp == -1 ? "off" : watermarks[resp];
                          });
                        }
                      },
                      child: waterMarks("Watermark", selectedWatermark)),
                  Divider(
                    color: Colors.grey,
                  ),
                  GestureDetector(
                      onTap: () {
                       _gettingCaptionAfterSelected(context);
                      },
                      child: waterMarks("Caption", "")),
                  const Divider(
                    color: Colors.grey,
                  ),
                  GestureDetector(
                      onTap: () {
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
                                primary:
                                    const Color.fromARGB(255, 125, 64, 121)),
                            onPressed: () {
                              _gettingScheduleAfterSelected(context);
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
                                primary:
                                    const Color.fromARGB(255, 73, 65, 125)),
                            onPressed: () {
                               _insert(_captionSelected[0]["title"], _captionSelected[0]["content"], widget.picprofile.toString(),
                                   _scheduleSelected.toString(), DateTime.now().toString(), _hashtagSelected.toString());
                               Navigator.pop(context, "save");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Post ",
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

  void _insert(title, content, photo, date_end, created_at, hashtags) async {
    Map<String, dynamic> row = {DatabaseHelper.columnTitleSchedulePosts: title,
    DatabaseHelper.columnContentSchedulePosts: content, DatabaseHelper.columnPhotoSchedulePosts: photo,
    DatabaseHelper.columnDateEndSchedulePosts: date_end, DatabaseHelper.columnCreateAtSchedulePosts: created_at,
    DatabaseHelper.columnHashtagsSchedulePosts: hashtags};
    SchedulePosts schedulePosts = SchedulePosts.fromMap(row);
    DatabaseHelper.instance.insert_schedule_post(schedulePosts);
    _showMessageInScaffold("Posts was Scheduled 👍 ");
  }

  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _gettingScheduleAfterSelected(BuildContext context) async {
    final result = await  Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScheduleRepost()));
    if (!mounted) return;
    setState(() {
      _scheduleSelected = result;
    });
    log(result.toString());
  }
  Future<void> _gettingHashtagsAfterSelected(BuildContext context) async {
    final result =  await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RepostHastags()));
    if(!mounted) return;
    setState(() {
      _hashtagSelected = result;
    });
  }
  Future<void> _gettingCaptionAfterSelected(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Caption(
                CustomCaption:
                widget.CustomCaption.toString())));

              if (!mounted) return;
                setState(() {
                 _captionSelected.add({"id": result["id"], "title": result["title"], "content": result["content"]});
                });


      }
}

