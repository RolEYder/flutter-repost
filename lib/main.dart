// @dart=2.9

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:repost/dashboard.dart';
import 'package:repost/screens/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _configuration =
    PurchasesConfiguration('appl_EfjAGDblTeCDGccRDhqThHQsiTN');
int initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Purchases.configure(_configuration);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  void initializationSettingsApp() async {
    if (initScreen == 0 || initScreen == null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool("notification", false);
      await preferences.setBool('history', true);
    }
  }

  @override
  void initState() {
    super.initState();
    initializationSettingsApp();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: const TextTheme(
              bodySmall: TextStyle(fontSize: 16, color: Colors.white),
              bodyLarge: TextStyle(fontSize: 24, color: Colors.white))),
      debugShowCheckedModeBanner: false,
      home: (initScreen == 0 || initScreen == null)
          ? OnboardingPage()
          : DashBoard(),
    );
  }
}
