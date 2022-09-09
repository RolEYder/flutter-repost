import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Watermark extends StatefulWidget {
  const Watermark({Key? key}) : super(key: key);

  @override
  State<Watermark> createState() => _WatermarkState();
}

class _WatermarkState extends State<Watermark> {
  List watermarks = ["Top Left", "Top Right", "Bottom Left", "Bottom Right"];
  List alignmentArr = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomLeft,
    Alignment.bottomRight
  ];
  int selectedAlignment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(left: 80, right: 80, top: 12),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 73, 65, 125),
                ),
                onPressed: () {
                  Navigator.pop(context, selectedAlignment);
                },
                child: Text("Select")),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/back.png")),
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text("Watermark"),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.green,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/smallgirl.png"),
                      ),
                    ),
                  ),
                  // Container(width: MediaQuery.of(context).size.width,height: 120,decoration: BoxDecoration(color: Colors.yellow,image: DecorationImage(image: AssetImage("assets/smallgirl.png"))),),
                  if (selectedAlignment >= 0) ...[
                    Align(
                      alignment: alignmentArr[selectedAlignment],
                      child: Image.asset(
                        "assets/watermark_img.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAlignment = -1;
                          });
                        },
                        child: Text(
                          "Deactivate Watermark",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
                itemExtent: 64,
                onSelectedItemChanged: (indexNo) {
                  setState(() {
                    selectedAlignment = indexNo;
                  });
                },
                children: watermarks
                    .map((e) => Center(
                          child: Text(
                            e,
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList()),
          )
        ],
      ),
    );
  }
}
