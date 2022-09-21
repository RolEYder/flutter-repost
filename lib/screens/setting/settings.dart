import 'package:flutter/material.dart';
import 'package:repost/screens/pro/proscreen.dart';
import 'package:repost/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notification = false;
  bool history = true;
  TextStyle HeaderStyle = TextStyle(
      color: Color.fromARGB(255, 114, 113, 113),
      fontSize: 18,
      fontWeight: FontWeight.bold);

  TextStyle insideStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  var account = ["My Acounts", "Clear History", "Restore Purchases"];
  var termspolicies = [
    "Terms of Service",
    "Privacy Policy",
    "Give Feedback",
    "Review Us"
  ];

  Widget _space() {
    return Divider(
      thickness: 0.5,
      color: Colors.grey[100],
    );
  }

  Widget height() => SizedBox(
        height: 10,
      );

  var edgeGap = const EdgeInsets.only(left: 12, bottom: 2);

  @override
  void initState() {
    settingApp();
    super.initState();
  }

  void settingApp() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      history = prefs.getBool("history") as bool;
      notification = prefs.getBool("notification") as bool;
    });
  }

  void setNotification(value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("notification", value);
  }

  void setClearHistory(value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("history", value);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/back.png")),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Subscribe to Pro Account",
                      style: insideStyle,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
            _space(),
            height(),
            _space(),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 2, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Allow Notifications",
                    style: insideStyle,
                  ),
                  SizedBox(
                    height: 30,
                    child: Switch.adaptive(
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.grey,
                        value: notification,
                        onChanged: (_) {
                          setState(() {
                            notification = !notification;
                            setNotification(notification);
                          });
                        }),
                  )
                ],
              ),
            ),
            _space(),
            const SizedBox(
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 2),
              child: Text(
                "ACCOUNT SETTINGS",
                style: HeaderStyle,
              ),
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Accounts",
                    style: insideStyle,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (history) {
                      history = !history;
                      // clear current post history
                      DatabaseHelper.instance.cleanHistory();
                      setClearHistory(false);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: history ? 1.0 : 0.5,
                      child: Text(
                        "Clear History",
                        style: insideStyle,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Restore Purchases",
                    style: insideStyle,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
            _space(),
            const SizedBox(
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 2),
              child: Text(
                "TERMS & POLICIES",
                style: HeaderStyle,
              ),
            ),
            _space(),
            for (int i = 0; i < termspolicies.length; i++) ...[
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      termspolicies[i],
                      style: insideStyle,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
              _space(),
            ],
            const SizedBox(
              height: 28,
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "LogOut",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  )
                ],
              ),
            ),
            _space()
          ],
        ),
      ),
    );
  }
}
