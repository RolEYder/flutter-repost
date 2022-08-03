
import 'package:flutter/material.dart';
import 'package:repost/helper/theme.dart';
import 'package:repost/screens/repost/Screen/repost_schedule_screen.dart';

class Stories extends StatelessWidget {
  List<String>? titleArr;
  List<String>? imgArr;
  String selectedTitle;
  bool showPostDetail;
  Function(String)? selectedStory;

  Stories(
      {Key? key,
      this.titleArr,
      this.imgArr,
      this.selectedTitle = "",
      this.selectedStory,
      this.showPostDetail = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < titleArr!.length; i++) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (selectedStory != null) {
                     selectedStory!(titleArr![i]);
                  }
                  if (showPostDetail) {
                    Navigator.push(context, MaterialPageRoute(builder: ((context) => RepostSchedule())));
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
                          gradient: (titleArr![i] == selectedTitle)
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
                            image: imgArr != null
                                ? DecorationImage(
                                    image: AssetImage("assets/${imgArr![i]}"))
                                : null),
                        width: 60,
                        height: 60,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(titleArr![i],
                        style:
                            TextStyle(fontSize: 13, color: secondaryTxtColor))
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
