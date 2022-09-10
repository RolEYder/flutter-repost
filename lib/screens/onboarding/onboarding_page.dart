import 'dart:io';

import 'package:flutter/material.dart';
import 'package:repost/dashboard.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:repost/models/onboarding_model.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  List<OnboardingModel> mySLides = [];
  int slideIndex = 0;
  late PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlidePageTile(
                imagePath: mySLides[0].getImageAssetPath(),
                title: mySLides[0].getTitle(),
                desc: mySLides[0].getDesc(),
              ),
              SlidePageTile(
                imagePath: mySLides[1].getImageAssetPath(),
                title: mySLides[1].getTitle(),
                desc: mySLides[1].getDesc(),
              ),
              SlidePageTile(
                imagePath: mySLides[2].getImageAssetPath(),
                title: mySLides[2].getTitle(),
                desc: mySLides[2].getDesc(),
              )
            ],
          ),
        ),
        bottomSheet: slideIndex != 2
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        controller.animateToPage(2,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.linear);
                      },
                      child: Text(
                        "SKIP",
                        style: TextStyle(
                            color: Color(0xFF0074E4),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          for (int i = 0; i < 3; i++)
                            i == slideIndex
                                ? _buildPageIndicator(true)
                                : _buildPageIndicator(false),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        print("this is slideIndex: $slideIndex");
                        controller.animateToPage(slideIndex + 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                      child: Text(
                        "NEXT",
                        style: TextStyle(
                            color: Color(0xFF0074E4),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              )
            : InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashBoard()));
                },
                child: Container(
                  // ignore: unnecessary_null_comparison
                  height: Platform.isIOS != null ? 70 : 60,
                  color: Colors.purple,
                  alignment: Alignment.center,
                  child: Text(
                    "GET STARTED NOW",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
      ),
    );
  }
}

class SlidePageTile extends StatelessWidget {
  String imagePath, title, desc;

  SlidePageTile(
      {required this.imagePath, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath),
          SizedBox(
            height: 40,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Text(desc,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14))
        ],
      ),
    );
  }
}
