import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ScheduleRepost extends StatefulWidget {
  const ScheduleRepost({Key? key}) : super(key: key);

  @override
  State<ScheduleRepost> createState() => _ScheduleRepostState();
}

class _ScheduleRepostState extends State<ScheduleRepost> {
  TimeOfDay date = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/back.png")),
        centerTitle: true,
        title: Text("Schedule Repost"),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  Text(
                    "By scheduling, you will receive a reminder notification to repost this post at the desired time.",
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      color: Color.fromARGB(255, 44, 43, 48),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SfDateRangePicker(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Time",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      showTimePicker(
                                          initialEntryMode:
                                              TimePickerEntryMode.input,
                                          context: context,
                                          initialTime: date);
                                    },
                                    child: Chip(
                                        label: Text(
                                      date.toString().substring(11, 15),
                                      style: TextStyle(fontSize: 14),
                                    ))),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
                  child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 73, 65, 125)),
                          onPressed: () {},
                          child: Text("Schedule"))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
