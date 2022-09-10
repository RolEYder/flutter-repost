// @dart=2.9
import 'package:flutter/material.dart';
import 'package:repost/dashboard.dart';
import 'package:repost/screens/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  // This widget is the root of your application.

  @override
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
