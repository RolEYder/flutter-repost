import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ScheduleRepost extends StatefulWidget {
  const ScheduleRepost({Key? key}) : super(key: key);

  @override
  State<ScheduleRepost> createState() => _ScheduleRepostState();
}

class _ScheduleRepostState extends State<ScheduleRepost> {
  TimeOfDay date = TimeOfDay.now();
   late DateTime  _getDate;
   late TimeOfDay  _getTime;

  @override
  void initState() {
    super.initState();
    setState(() {
      _getTime = TimeOfDay.now();
      _getDate =  DateTime.now();
    });
  }


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
                         SfDateRangePicker(onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                           final dynamic value = args.value;
                           setState(() {
                             _getDate = value;
                           });
                           log(_getDate.toString());
                         }),

                          Padding(
                            padding: const EdgeInsets.all(6.0),
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
                                          initialTime: _getTime).then(( value) {
                                            if(value != null) {
                                              setState(() {
                                                _getTime = value;
                                              });
                                              log(_getTime.toString());
                                            }
                                      });
                                    },
                                    child: Chip(
                                        label: Text(
                                      _getTime.toString().substring(11, 15),
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
                          onPressed: () {
                            String dateTime = DateFormat('yyyy-mm-dd').format(_getDate).toString() + ' ' +  _getTime.hour.toString() + ':' + _getTime.minute.toString();
                            final DateEnd = DateTime.parse(dateTime);
                            Navigator.pop(context, DateEnd);
                          },
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
