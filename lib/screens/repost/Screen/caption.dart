import 'package:flutter/material.dart';
import 'editing_custom_caption.dart';

class Caption extends StatefulWidget {
  final String CustomCaption;

  const Caption({Key? key, required this.CustomCaption}) : super(key: key);

  @override
  State<Caption> createState() => _CaptionState();
}

class _CaptionState extends State<Caption> {
  bool rememberMe = false;

  List isCheckedbox = [];
  late List<dynamic> data = [
    {"title": "Custom", "description": "Choose to Edit"},
    {"title": "Original", "description": widget.CustomCaption.toString()}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 22, right: 22, top: 18, bottom: 18),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 73, 65, 125)),
              onPressed: () {},
              child: Text("Save")),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset("assets/back.png"),
        ),
        title: Text("Caption"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditingCustomCaption()));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data[index]["title"],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        data[index]["description"],
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isCheckedbox.contains(index)) {
                              isCheckedbox.remove(index);
                            } else {
                              isCheckedbox.add(index);
                            }
                          });
                        },
                        child: isCheckedbox.contains(index)
                            ? Icon(
                                Icons.check_circle,
                                color: Color.fromARGB(255, 0, 8, 239),
                                size: 22,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white)),
                                width: 22,
                                height: 22,
                              ),
                      )
                    ],
                  ),
                  Text("#priceless #sofun",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
