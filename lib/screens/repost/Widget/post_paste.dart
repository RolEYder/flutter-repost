import 'package:flutter/material.dart';
import 'package:repost/screens/repost/Screen/repost_schedule_screen_paste.dart';
import 'package:repost/services/database_service.dart';
import 'package:repost/models/searcherPost_model.dart';

class PostPasted extends StatefulWidget {
  final String uid;
  final String username;
  final bool is_video;
  final String caption;
  final String display_url;
  final List<Map<String, dynamic>> content;
  late final String profile_pic_url;
  PostPasted(
      {Key? key,
      required this.uid,
      required this.username,
      required this.caption,
      required this.display_url,
      required this.content,
      required this.is_video,
      required this.profile_pic_url})
      : super(key: key);
  @override
  State<PostPasted> createState() => _PostState();
}

class _PostState extends State<PostPasted> {
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RepostSchedulePasted(
                              content: widget.content,
                              display_url: widget.display_url,
                              is_video: widget.is_video,
                              profile_pic_url:
                                  widget.profile_pic_url.toString(),
                              caption: widget.caption.toString(),
                              username: widget.username,
                              uid: widget.uid,
                            )));
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
                        child: Stack(
                          children: <Widget>[
                            SizedBox(
                              height: 125,
                              width: 130,
                              child: Image.network(
                                widget.display_url.toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                            (widget.is_video)
                                ? new Positioned(
                                    bottom: 10,
                                    right:
                                        10, //give the values according to your requirement
                                    child: Icon(
                                      Icons.videocam,
                                      color: Colors.white,
                                    ),
                                  )
                                : (!widget.is_video &
                                        !widget.content.isEmpty &
                                        (widget.content.length > 1))
                                    ? new Positioned(
                                        bottom: 10,
                                        right:
                                            10, //give the values according to your requirement
                                        child: Icon(
                                          Icons.content_copy,
                                          color: Colors.white,
                                        ),
                                      )
                                    : new Positioned(
                                        bottom: 10,
                                        right:
                                            10, //give the values according to your requirement
                                        child: Icon(
                                          Icons.image,
                                          color: Colors.white,
                                        ),
                                      ),
                          ],
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
                                            widget.profile_pic_url.toString()),
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
                                widget.caption.toString(),
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
                                "Reminder:January 25 2022 3:45PM",
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

  //save clicked posts

  Future<void> _saveClickedPosts(
      content, uid, profilepic, thumbnailpic, username) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnContentPostsSearches: content,
      DatabaseHelper.columnCodePostSearches: uid,
      DatabaseHelper.columnProfilePicPostsSearches: profilepic,
      DatabaseHelper.columnThumbnailPicPostsSearches: thumbnailpic,
      DatabaseHelper.columnUsernamePostsSearches: username,
      DatabaseHelper.columnCreatedAtPostsSearches: DateTime.now().toString()
    };
    SearchersPosts searchersPosts = SearchersPosts.fromMap(row);
    DatabaseHelper.instance.insert_searcher_post(searchersPosts);
  }
}
