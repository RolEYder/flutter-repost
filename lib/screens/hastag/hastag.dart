import 'package:flutter/material.dart';
import 'package:repost/helper/theme.dart';
import 'package:repost/screens/repost/Widget/stories.dart';

import 'selected_hastag.dart';

class Hastag extends StatefulWidget {
  const Hastag({Key? key}) : super(key: key);

  @override
  State<Hastag> createState() => _HastagState();
}

class _HastagState extends State<Hastag> {
  Color color1 = Colors.grey;
  Color color2 = Color.fromARGB(255, 70, 62, 147);
  final TextEditingController _post = TextEditingController();
  // int stoyindex = 0;

  var selectedhastag = [];

  var hastag = [
    "#DLORENZW",
    "#ADLORENZW",
    "#XORENZW",
    "#QORENZW",
    "#AXOUF",
    "#HURTY",
    "#DLORENZW",
    "#DLORENZW",
    "#GOTYU",
    "#LOOKIU",
    "#LEISURE",
    "#XYZ",
    "#DLORENZW",
    "#DLORENZW",
    "#ADLORENZW",
    "#XORENZW",
    "#QORENZW",
    "#AXOUF",
    "#HURTY",
    "#DLORENZW",
    "#GOTYU",
    "#LOOKIU",
    "#LEISURE",
    "#XYZ",
    "#DLORENZW",
    "#DLORENZW",
    "#ADLORENZW",
    "#XORENZW",
    "#QQORENZW",
    "#AXOUF",
    "#HURTY",
    "#DLORENZW",
    "#GOTYU",
    "#LOOKIU",
    "#LEISURE",
    "#XYZ",
    "#DLORENZW",
    "#DLORENZW",
    "#ADLORENZW",
    "#XORENZW",
    "#QORENZW",
    "#AXOUF",
    "#HURTY",
    "#DLORENZW",
    "#GOTYU",
    "#LOOKIU",
    "#LEISURE",
    "#XYZ",
    "#DLORENZW",
    "#TEST"
  ];

  List<String> categoryTitleArr = [
    "TOP 8",
    "HOLIDAYS",
    "BUSINESS",
    "FOOD",
    "HEALTH",
    "FASHION",
    "FITNESS",
    "DESIGN",
    "ARTS",
    "DIY",
    "PETS",
    "TRAVEL"
  ];
  List<String> categoryImgArr = [
    "category1.png",
    "category2.png",
    "category3.png",
    "category4.png",
    "category5.png",
    "category6.png",
    "category7.png",
    "category8.png",
    "category9.png",
    "category10.png",
    "category11.png",
    "category12.png",
  ];
  String selectedCategory = "";

  @override
  void initState() {
    super.initState();
    selectedCategory = categoryTitleArr[0];
    selectedhastag = List.filled(hastag.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          top: 12,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0, left: 8),
              child: TextField(
                style: const TextStyle(fontSize: 16),
                onSubmitted: (value) {},
                controller: _post,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintStyle: const TextStyle(color: Colors.grey),
                    hintText: "Search",
                    suffixIcon: IconButton(
                      onPressed: _post.clear,
                      icon: Icon(Icons.clear),
                      iconSize: 16,
                      color: Colors.white,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 58, 57, 57),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8))),
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20, left: 8, top: 8, bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 92, 84, 144)),
                          onPressed: () {
                            List selectedHashTagArr = [];
                            for (var i = 0; i < selectedhastag.length; i++) {
                              if (selectedhastag[i]) {
                                selectedHashTagArr.add(hastag[i]);
                              }
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SelectedHastag(selectedHashTagArr)));
                          },
                          child: Text("Copy Selected hashtags")),
                    ),
                  ),
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Icon(
                        Icons.file_copy_outlined,
                        color: Colors.white,
                      ),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ], color: primaryColor, shape: BoxShape.circle),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Text(
                      "CATEGORIES",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "Stories you have already reposted",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stories(
                      titleArr: categoryTitleArr,
                      imgArr: categoryImgArr,
                      selectedTitle: selectedCategory,
                      selectedStory: (title) {
                        setState(() {
                          selectedCategory = title;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      selectedCategory,
                      style: TextStyle(
                          fontSize: 40,
                          height: 0.95,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Color.fromARGB(255, 125, 125, 125),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Wrap(
                          children: [
                            for (int i = 0; i < hastag.length; i++) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 4, left: 4, bottom: 4),
                                child: SizedBox(
                                    height: 30,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedhastag[i] =
                                              !selectedhastag[i];
                                        });
                                      },
                                      child: Chip(
                                        backgroundColor: selectedhastag[i]
                                            ? Color.fromARGB(255, 70, 62, 147)
                                            : Colors.grey,
                                        label: Text(
                                          hastag[i],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 4,
                              )
                            ],
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
