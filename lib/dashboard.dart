import 'package:flutter/material.dart';
import 'package:repost/helper/StringExtension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/hastag/hastag.dart';
import 'screens/more/morescreen.dart';
import 'screens/pro/proscreen.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'screens/repost/Screen/repost_screen.dart';
import 'screens/schedule/schedule_screen.dart';
import 'screens/setting/settings.dart';
import 'services/database_service.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    super.initState();
    proScreenEveryDay();
    DatabaseHelper.instance.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  int index = 0;
  selectedPage(int selectedTitle) {
    setState(() {
      index = selectedTitle;
    });

    // if (index == 3) {
    //   Navigator.pushReplacement(
    //       context, MaterialPageRoute(builder: (context) => ProScreen()));
    // }

    print(selectedTitle);
  }

  List pages = [
    {"title": "Repost +"},
    {"title": "Schedule"},
    {"title": "Hashtag"},
    {"title": "More"}
  ];

  List titleArr = ["repost", "schedule", "hashtags", "more"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                //  reteApplication(context);
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
                  _launchInstagramApp(context);
                },
                icon: Image.asset("assets/post.png"))
          ],
          centerTitle: true,
          title: Text(pages[index]["title"]),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
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
          MoreScreen()
        ]),
      ),
    );
  }


  Future<void> proScreenEveryDay() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int? lastAccess = sharedPreferences.getInt('lastAccess');
    String? subscription = sharedPreferences.getString("subscription");

    if (lastAccess != null && subscription == "free") {
      final DateTime lastAccessTime =
          DateTime.fromMillisecondsSinceEpoch(lastAccess);
      final opened = lastAccessTime.isAfter(DateTime.now());
      if (!opened) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProScreen()));
      }
    }
  }

  Future<void> _launchInstagramApp(BuildContext context) async {
    const nativeUrl = "instagram://";
    await LaunchApp.openApp(
        iosUrlScheme: nativeUrl,
        appStoreLink: "https://apps.apple.com/us/app/instagram/id389801252");
  }
}
