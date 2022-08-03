import 'package:flutter/material.dart';
import 'package:repost/screens/repost/Widget/stories.dart';

class RepostHastags extends StatefulWidget {
  const RepostHastags({Key? key}) : super(key: key);

  @override
  State<RepostHastags> createState() => _RepostHastags();
}

class _RepostHastags extends State<RepostHastags> {
  List selectedhastags = [];
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
    selectedhastags = List.filled(hashtags.length, false);
  }

  @override
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
          title: Text("Hastags"),
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
              Text(selectedCategory,
                  style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Card(
                  color: Colors.grey,
                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4,left: 4),
                    child: Wrap(
                      runSpacing: -8,
                      children: [
                        for (int i = 0; i < hashtags.length; i++) ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 2),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedhastags[i] = !selectedhastags[i];
                                });
                              },
                              child: Chip(
                                  backgroundColor:
                                      selectedhastags[i]
                                          ? Color.fromARGB(255, 70, 62, 147)
                                          : Color.fromARGB(255, 190, 184, 184),
                                  label: Text(
                                    hashtags[i],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  )),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              ),
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
                        hashtags[i],
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
                          onPressed: () {},
                          child: Text("Save"))))
            ],
          ),
        ));
  }
}
