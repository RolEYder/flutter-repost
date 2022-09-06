import 'package:flutter/material.dart';
import 'package:repost/dashboard.dart';

class SceduleTime extends StatefulWidget {
  const SceduleTime({Key? key}) : super(key: key);

  @override
  State<SceduleTime> createState() => _SceduleTimeState();
}

class _SceduleTimeState extends State<SceduleTime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DashBoard(),
                    ));
              },
              child: Icon(Icons.crop_square)),
          centerTitle: true,
          title: Text("Schedule Repost"),
        ),
        body: Column(
          children: [
            Expanded(
                child: Container(
              color: Colors.green,
            )),
            Expanded(
                flex: 3,
                child: Container(
                  color: Colors.red,
                  child: DatePickerDialog(
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(Duration(days: 1)),
                      lastDate: DateTime.utc(3000)),
                )),
            Expanded(
                child: Container(
              color: Colors.blue,
            ))
          ],
        ));
  }
}
