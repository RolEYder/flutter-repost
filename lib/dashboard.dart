import 'package:flutter/material.dart';
import 'package:repost/helper/StringExtension.dart';
import 'screens/hastag/hastag.dart';
import 'screens/more/morescreen.dart';
import 'screens/pro/proscreen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'screens/repost/Screen/repost_screen.dart';
import 'screens/schedule/schedule_screen.dart';
import 'screens/setting/settings.dart';
import 'services/database_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
    DatabaseHelper.instance.initializeDB().whenComplete(() async {
      setState(() {
        DatabaseHelper.instance.deleteDatabase();
      });
    });
  }

  static final String oneSignalAppId = "48194e35-d4ef-4265-bf2f-d28da15b8ac3";
  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
  }

  int index = 0;
  selectedPage(int selectedTitle) {
    setState(() {
      index = selectedTitle;
    });

    if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ProScreen()));
    }

    print(selectedTitle);
  }

  List pages = [
    {"title": "Repost +"},
    {"title": "Schedule"},
    {"title": "Hashtag"},
    {"title": "Pro"},
    {"title": "More"}
  ];

  List titleArr = ["report", "schedule", "hashtags", "pro", "more"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  Color.fromARGB(255, 69, 40, 96),
                  Color.fromARGB(255, 41, 31, 68)
                ])),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
              icon: const Icon(
                Icons.settings_sharp,
                size: 20,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  _launchInstagramApp(Uri.parse("https://www.instagram.com"));
                },
                icon: Image.asset("assets/post.png"))
          ],
          centerTitle: true,
          title: Text(pages[index]["title"]),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color.fromARGB(255, 69, 40, 96),
                Color.fromARGB(255, 41, 31, 68)
              ])),
          child: TabBar(
              labelStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              onTap: selectedPage,
              indicatorColor: Colors.transparent,
              labelColor: Colors.white,
              tabs: [
                for (int x = 0; x < titleArr.length; x++) ...[
                  Tab(
                    icon: Image.asset(
                      width: 32,
                      "assets/${titleArr[x]}_unselected.png",
                      color: index == x ? Colors.white : Colors.grey,
                    ), //Icon(Icons.sync),
                    text: titleArr[x].toString().capitalize(),
                  )
                ]
              ]),
        ),
        body: TabBarView(physics: NeverScrollableScrollPhysics(), children: [
          RepostScreen(),
          ScheduleScreen(),
          Hastag(),
          Icon(Icons.star),
          MoreScreen()
        ]),
      ),
    );
  }

  Future<void> _launchInstagramApp(_url) async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}
