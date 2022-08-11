import 'package:flutter/material.dart';
import 'package:repost/helper/theme.dart';
import 'package:repost/screens/repost/Screen/repost_schedule_screen.dart';
import 'package:repost/screens/repost/Widget/post.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const Text(
              "PENDING\nPOSTS\nAND\nSTORIES",
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
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RepostSchedule(
                                picprofile: "",
                              )));
                },
                child: Text("Example"))
          ],
        ),
      ),
    );
  }
}
