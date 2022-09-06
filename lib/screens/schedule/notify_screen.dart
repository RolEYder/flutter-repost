import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ScheduleRepost extends StatefulWidget {
  const ScheduleRepost({Key? key}) : super(key: key);

  @override
  State<ScheduleRepost> createState() => _ScheduleRepostState();
}

class _ScheduleRepostState extends State<ScheduleRepost> {
  TimeOfDay date = TimeOfDay.now();

    DateTime? _getDate;
    TimeOfDay?  _getTime;

  @override
  void initState() {
    super.initState();
    loadInitial();
    setState(()  {
      _getTime = TimeOfDay.now();
    });
  }
  @override
void dispose() {
    setDate(_getDate);
    super.dispose();
  }

  void setDate(_getDate) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Date', _getDate.toString());
  }

  Future<void> loadInitial() async {

    final prefs =  await SharedPreferences.getInstance();
    print(prefs.getString('Date').toString());
    setState(() {
      _getDate =  (prefs.getString('Date').toString().length != 0)? prefs.getString('Date') as DateTime : DateTime.now();
    });
    print(_getDate.toString());
  }
  Future<DateTime> getDate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _getDate = prefs.getString('Date') as DateTime;
    });
    return prefs.getString('Date') as DateTime;
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
                         SfDateRangePicker(enablePastDates: false, initialSelectedDate: _getDate, onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                           final dynamic value = args.value;
                           setState(() {
                             setDate(value);
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
                                          initialTime: _getTime!).then(( value) {
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
                            String minute = _getTime!.minute.toString().length == 1 ? "0"+_getTime!.minute.toString() : _getTime!.minute.toString();
                            String dateTime = DateFormat('yyyy-mm-dd').format(_getDate!).toString() + ' ' +  _getTime!.hour.toString() + ':' + minute ;
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
