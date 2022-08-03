import 'package:flutter/material.dart';

class Posts extends StatelessWidget {
  const Posts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      child: Image.asset(
                        "assets/smallgirl.png",
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: const [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundImage:
                                        AssetImage("assets/smallgirl.png"),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "alina.sde1",
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
                        const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(
                            "Having Fun While Taking picture is the best in the World!!! #Priceless #sofun ",
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
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
