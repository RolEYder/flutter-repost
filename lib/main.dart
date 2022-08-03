import 'package:flutter/material.dart';
import 'package:repost/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: const TextTheme(
              bodySmall: TextStyle(fontSize: 16, color: Colors.white),
              bodyLarge: TextStyle(fontSize: 24, color: Colors.white))),
      home: DashBoard(),
    );
  }
}
