import 'package:flutter/material.dart';
import 'package:repost/services/database_service.dart';
import 'package:repost/models/searcherPost_model.dart';

class PostSchedule extends StatefulWidget {
  final String uid;
  final String username;
  final String text;
  final String thumbnail;
  final String remainder;
  final String profilePic;
  PostSchedule(
      {Key? key,
      required this.remainder,
      required this.uid,
      required this.username,
      required this.text,
      required this.thumbnail,
      required this.profilePic})
      : super(key: key);
  @override
  State<PostSchedule> createState() => _PostState();
}

class _PostState extends State<PostSchedule> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                // //saving clicked posts
                // _saveClickedPosts(widget.text, widget.uid, widget.profilePic,
                //     widget.thumbnail, widget.username);
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => RepostSchedule(
                //               picprofile: widget.thumbnail.toString(),
                //               CustomCaption: widget.text.toString(),
                //               username: widget.username,
                //               uid: widget.uid,
                //             )));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                        child: SizedBox(
                          height: 125,
                          child: Image.network(
                            widget.thumbnail.toString(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                            // color: Color.fromARGB(255, 74, 68, 82),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Color.fromARGB(255, 74, 68, 82),
                                  Color.fromARGB(255, 74, 68, 82),
                                ])),
                        height: 125,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundImage: NetworkImage(
                                            widget.profilePic.toString()),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.username.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                widget.text.toString(),
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 13.0),
                              child: Text(
                                "Reminder: ${widget.remainder}",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 8),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ));
        });
  }
}
