import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:repost/helper/theme.dart';
import 'package:repost/screens/repost/Widget/stories.dart';
import 'package:http/http.dart' as http;
import '../repost/Screen/repost_schedule_screen.dart';
import 'selected_hastag.dart';
import 'package:repost/helper/herpers.dart' as Helpers;
class Hastag extends StatefulWidget {
  const Hastag({Key? key}) : super(key: key);

  @override
  State<Hastag> createState() => _HastagState();
}

class _HastagState extends State<Hastag> {
  Color color1 = Colors.grey;
  Color color2 = Color.fromARGB(255, 70, 62, 147);
  final TextEditingController _post = TextEditingController();
  List<String> _listHashtags = [];
  bool showPostDetail = false;
  String? selectedTitle;
  bool _isLoadingHashtagList = false;
  Function(String)? selectedStory;
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

  List<String>? categoryTitleArr = [
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
  List<String>? categoryImgArr = [
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
  void _fetchHashtagByCategory(String category) async {

    List<String> _hashtags = [];
    // url
    final url = "https://instahashtag.p.rapidapi.com/instahashtag?tag=" + category;
    final http.Response response = await http.get(Uri.parse(url), headers: {
      "X-RapidAPI-Key": "cb42a464cbmsh5d08b3d42135b64p1de875jsn9ef075c0c463",
      "X-RapidAPI-Host": "instahashtag.p.rapidapi.com",
    });
    if (response.statusCode == 200) {
      _hashtags = Helpers.getHashtagsFromString(response.body.toString());
    }
    else {
       _hashtags.add("API hashtag failure");
    }
    log(_hashtags.toString());
    log(_hashtags.toString());
    setState(() {
      _listHashtags = _hashtags;
      _isLoadingHashtagList = false;
    });
  }

  @override
  void initState() {
    super.initState();
    showPostDetail = false;
    _fetchHashtagByCategory("TOP8");
    selectedCategory = categoryTitleArr![0];
    selectedhastag = List.filled(100, false);
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
                   SingleChildScrollView(scrollDirection: Axis.horizontal,
                     child:  Row(
                       children: [
                         for (int i = 0; i < this.categoryTitleArr!.length; i++) ...[
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: GestureDetector(
                               onTap: () {
                                  setState(() {
                                    selectedCategory = this.categoryTitleArr![i].toString();
                                    this._isLoadingHashtagList = true;
                                    _fetchHashtagByCategory(this.categoryTitleArr![i].toString().replaceAll(' ', ''));
                                  });
                                   if (this.selectedStory != null) {
                                  setState(() {
                                       this.selectedCategory = this.categoryTitleArr![i];
                                       this.selectedStory!(this.categoryTitleArr![i]);
                                     });
                                 }
                                 if (showPostDetail) {
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                           builder: ((context) => RepostSchedule(
                                             picprofile: "/assets/category4.png",
                                             CustomCaption: "Custom",
                                           ))));
                                 }
                               },
                               child: Column(
                                 children: [
                                   Container(
                                     padding: EdgeInsets.all(2),
                                     width: 67,
                                     height: 67,
                                     decoration: BoxDecoration(
                                         color: Colors.white,
                                         shape: BoxShape.circle,
                                         gradient: (this.categoryTitleArr![i] == this.selectedTitle)
                                             ? LinearGradient(
                                             begin: Alignment.topCenter,
                                             end: Alignment.bottomCenter,
                                             colors: [
                                               Color(0xFF9B2282),
                                               Color(0xFFEEA863)
                                             ])
                                             : null),
                                     child: Container(
                                       decoration: BoxDecoration(
                                           boxShadow: [
                                             BoxShadow(color: Colors.grey, spreadRadius: 1)
                                           ],
                                           color: Colors.grey,
                                           shape: BoxShape.circle,
                                           image: this.categoryImgArr != null
                                               ?  DecorationImage(
                                               image:  AssetImage("assets/${this.categoryImgArr![i]}"))
                                               : null),
                                       width: 60,
                                       height: 60,
                                     ),
                                   ),
                                   SizedBox(height: 5),
                                   Text(this.categoryTitleArr![i],
                                       style:  TextStyle(fontSize: 13, color: secondaryTxtColor))
                                 ],
                               ),
                             ),
                           ),
                         ]
                       ],
                     )
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
                   !_isLoadingHashtagList?  Card(
                     color: Color.fromARGB(255, 125, 125, 125),
                     child: Padding(
                       padding: EdgeInsets.all(8),
                       child:  Wrap(
                         children: [
                           for (int i = 0; i < _listHashtags.length; i++) ...[
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
                                         _listHashtags[i],
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
                   ) :  SizedBox(height: 50, width: 50,
                   child: CircularProgressIndicator()),
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
