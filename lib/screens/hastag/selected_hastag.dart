import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SelectedHastag extends StatefulWidget {
  var selectedhastag;

  SelectedHastag(this.selectedhastag);

  @override
  State<SelectedHastag> createState() => _SelectedHastagState();
}

class _SelectedHastagState extends State<SelectedHastag> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/back.png")),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Color.fromARGB(255, 69, 40, 96),
                Color.fromARGB(255, 41, 31, 68)
              ])),
        ),
        title: Text("Selected Hashtags"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Card(
                color: Color.fromARGB(255, 125, 125, 125),
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                child: Wrap(
                  children: [
                    for (int i = 0; i < widget.selectedhastag.length; i++) ...[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 30,
                          child: Chip(
                              backgroundColor: Color.fromARGB(255, 70, 62, 147),
                              label: Text(
                                widget.selectedhastag[i],
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              )),
                        ),
                      )
                    ]
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "Preview",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: [
                    for (int i = 0; i < widget.selectedhastag.length; i++) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          widget.selectedhastag[i],
                          style: TextStyle(color: Colors.grey),
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      )
                    ]
                  ],
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 70, 62, 147)),
                        onPressed: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AlertDialog(
                                      actionsAlignment:
                                          MainAxisAlignment.center,
                                      backgroundColor: const Color(0xff3b3b3d),
                                      title: Center(
                                        child: Text(
                                          "Sucess",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22),
                                        ),
                                      ),
                                      content: Center(
                                        child: Text("Hashtags copied",
                                            style: const TextStyle(
                                                color: Colors.white)),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Color(0xff0985ff)),
                                            )),
                                      ],
                                    ),
                                  ],
                                );
                              });

                          FlutterClipboard.copy(
                              widget.selectedhastag.join(" "));
                          print(widget.selectedhastag.join());
                        },
                        child: const Text("Copy to Clipboard")),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
