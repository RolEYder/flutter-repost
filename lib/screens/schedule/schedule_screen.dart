// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:repost/helper/theme.dart';
import 'package:repost/screens/repost/Widget/post_schedule.dart';
import 'package:repost/services/database_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  List<dynamic> _schedulePosts = [];
  bool _isEmpltySchedulePost = true;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getSchedulePosts();
    }
  }

  void dispose() {
    showSchedulePosts();
    super.dispose();
  }

  Widget showSchedulePosts() {
    return (Column(children: <Widget>[
      ..._schedulePosts.map((e) => PostSchedule(
            uid: e["id"].toString(),
            remainder: e['date_end'],
            username: e["username"],
            profilePic: e["profile_pic"],
            text: (e["content"].toString()),
            thumbnail: e["photo"].toString(),
          ))
    ]));
  }

  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const Text(
              "PENDING POSTS AND STORIES",
              style: TextStyle(
                  fontSize: 50,
                  height: 0.95,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Click to edit your desired scheduled post or story.",
              style: TextStyle(color: secondaryTxtColor),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              child: showSchedulePosts(),
            )
          ],
        ),
      ),
    );
  }

  void getSchedulePosts() async {
    final _schedule = await DatabaseHelper.instance.getAllSchedulePosts();
    if (_schedule.isNotEmpty) {
      setState(() {
        if (mounted) {
          _schedulePosts = _schedule;
          _isEmpltySchedulePost = false;
        }
      });

      showSchedulePosts();
    } else {
      setState(() {
        if (mounted) {
          _isEmpltySchedulePost = true;
        }
      });
    }
  }
}
