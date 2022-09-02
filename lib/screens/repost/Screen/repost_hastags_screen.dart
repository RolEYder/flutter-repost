import 'package:flutter/material.dart';
import 'package:repost/helper/herpers.dart' as Helpers;
import 'package:http/http.dart' as http;
import 'dart:developer';
import '../../../helper/theme.dart';
import '../../repost/Screen/repost_schedule_screen.dart';

class RepostHastags extends StatefulWidget {
  const RepostHastags({Key? key}) : super(key: key);

  @override
  State<RepostHastags> createState() => _RepostHastags();
}

class _RepostHastags extends State<RepostHastags> {
  List<String> _listHashtags = [];
  List<String> _clickedHashtags = [];
  bool showPostDetail = false;
  String? selectedTitle;
  bool _isLoadingHashtagList = false;
  Function(String)? selectedStory;
  List selectedhastags = [];
  var selectedhastag = [];
  List hashtags = [
    "#DLORENZW",
    "#ALDORENZW",
    "#XORENZW",
    "#QORENZW",
    "#AXOUF",
    "#HURTY",
    "#DOLRENZW",
    "#GOTYU",
    "#LOOKIU",
    "#LEISURE",
    "#XYZ",
    "#DLORENZW",
    "#DLORENZW",
    "#ALDORENZW",
    "#XORENZW",
    "#QORENZW",
    "#AXOUF"
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
      log(response.body.toString());
      _hashtags.add("API hashtag failure");
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 28, 28, 28),
        appBar: AppBar(
          actions: [Image.asset("assets/post.png")],
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset("assets/back.png")),
          title: Text("Hashtags"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 12, top: 8),
          child: ListView(
            children: [
              Text(
                "CATEGORIES",
                style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "Stories you have already reposted",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 15,
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
                                          username: "",
                                          uid: "",
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
              Text(selectedCategory,
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
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
                                    _clickedHashtags.add(_listHashtags[i]);
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
              SizedBox(
                height: 15,
              ),
              Text(
                "Preview",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Container(
                child: Wrap(
                  children: [
                    for (int i = 0; i < selectedhastags.length; i++) ...[
                      if(selectedhastags[i])...[
                      Text(
                        _listHashtags[i],
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 4,
                      )]
                    ]
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(right: 20, left: 20, top: 10),
                  child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 70, 62, 147)),
                          onPressed: () {
                            Navigator.pop(context, _clickedHashtags);
                          },
                          child: Text("Save"))))
            ],
          ),
        ));
  }
}
