import 'package:flutter/material.dart';
import 'package:repost/models/caption_model.dart';
import 'editing_custom_caption_screen.dart';
import 'package:repost/services/database_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Caption extends StatefulWidget {
  final String? CustomCaption;
  final String username;
  final String OriginalCaption;
  const Caption(
      {Key? key,
      required this.username,
      required this.OriginalCaption,
      required this.CustomCaption})
      : super(key: key);
  @override
  State<Caption> createState() => _CaptionState();
}

class _CaptionState extends State<Caption> with WidgetsBindingObserver {
  bool rememberMe = false;
  final dbHelper = DatabaseHelper.instance;
  List<Captions> captions = [];
  // ignore: unused_field
  bool _isLoading = false;
  late List<Map<String, dynamic>> _savedCaptions = [];
  List isCheckedbox = [];

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    setState(() {
      _isLoading = true;
      getAllUserSavedCaptions();
    });
  }

//// override this function
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) refresh();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 22, right: 22, top: 18, bottom: 18),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 73, 65, 125)),
              onPressed: () {
                Navigator.pop(context, _savedCaptions[this.isCheckedbox[0]]);
              },
              child: Text(AppLocalizations.of(context)!.save)),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset("assets/back.png"),
        ),
        title: Text(AppLocalizations.of(context)!.caption),
        actions: [
          PopupMenuButton(
            onSelected: (res) {
              if (res == 0) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditingCustomCaption(
                        Username: widget.username,
                        OriginalCaption: widget.OriginalCaption,
                        title: "",
                        content: "")));
              }
              ;
            },
            itemBuilder: (ctx) {
              return [
                PopupMenuItem(
                    value: 0,
                    child: Row(children: [
                      Icon(Icons.add, color: Colors.black),
                      Text(AppLocalizations.of(context)!.add_caption)
                    ])),
              ];
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: _savedCaptions.isNotEmpty
                ? ListView.builder(
                    itemCount:
                        _savedCaptions.length == 0 ? 1 : _savedCaptions.length,
                    itemBuilder: ((context, index) {
                      Map<String, dynamic> item = (_savedCaptions.isEmpty)
                          ? {"title": "Custom", "content": "Choose to Edit"}
                          : _savedCaptions[index];
                      return Dismissible(
                        key: UniqueKey(),
                        child: GestureDetector(
                          onTap: () {
                            saveNewCaption(context, index);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _savedCaptions.isEmpty
                                    ? " "
                                    : _savedCaptions[index]["title"],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    _savedCaptions.isEmpty
                                        ? " "
                                        : _savedCaptions[index]["content"],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )),
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (isCheckedbox.contains(index)) {
                                          isCheckedbox.remove(index);
                                        } else {
                                          isCheckedbox.clear();
                                          isCheckedbox.add(index);
                                        }
                                      });
                                    },
                                    child: isCheckedbox.contains(index)
                                        ? Icon(
                                            Icons.check_circle,
                                            color:
                                                Color.fromARGB(255, 0, 8, 239),
                                            size: 22,
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white)),
                                            width: 22,
                                            height: 22,
                                          ),
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (DismissDirection dir) {
                          List<Map<String, dynamic>> map =
                              List<Map<String, dynamic>>.from(
                                  this._savedCaptions);
                          map.removeAt(index);
                          // removing from database
                          DatabaseHelper.instance
                              .delete(this._savedCaptions[index]["id"]);
                          setState(() => {this._savedCaptions = map});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                duration: const Duration(seconds: 3),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.error_outline, size: 32),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Text(
                                          dir == DismissDirection.startToEnd
                                              ? 'removed'
                                              : '$index update'),
                                    ),
                                  ],
                                ),
                                action: SnackBarAction(
                                  label: 'UNDO',
                                  onPressed: () {
                                    List<Map<String, dynamic>> map =
                                        List<Map<String, dynamic>>.from(
                                            this._savedCaptions);
                                    map.insert(index, item);
                                    Captions caption = Captions.fromMap(item);
                                    DatabaseHelper.instance.insert(caption);
                                    setState(() {
                                      this._savedCaptions = map;
                                    });
                                  },
                                )),
                          );
                        },
                        background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerLeft,
                            child: const Icon(Icons.delete)),
                        secondaryBackground: Container(
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                          child: const Icon(Icons.save),
                        ),
                      );
                    }),
                  )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //main axis the vertical axis in a column so this positions the children at the center of the vertical axis
                    crossAxisAlignment: CrossAxisAlignment
                        .center, //the horizontal axis of a column, again we position the children's at the center of the horizontal axis
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.captions_not_found,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ))),
      ),
    );
  }

  Future refresh() async {
    getAllUserSavedCaptions();
  }

  void showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> saveNewCaption(BuildContext context, int index) async {
    final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditingCustomCaption(
                    Username: widget.username,
                    OriginalCaption: widget.OriginalCaption,
                    title: _savedCaptions[index]["title"].toString(),
                    content: _savedCaptions[index]["content"].toString(),
                    id: _savedCaptions[index]["id"])))
        .whenComplete(() => refresh());
    if (!mounted) return;
    // After the Selection Screen returns a result, hide any previous nackbars
    // and show the new result.
    if (result == "save") {
      getAllUserSavedCaptions();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text('New caption added successfully 👍')));
      refresh();
    } else if (result == "update") {
      getAllUserSavedCaptions();
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
            SnackBar(content: Text('New caption updated successfully 👍')));
      refresh();
    }
  }

  void getAllUserSavedCaptions() async {
    final allRows = await dbHelper.getAllRows();
    if (allRows.isNotEmpty) {
      allRows.forEach((row) => captions.add(Captions.fromMap(row)));
      showMessageInScaffold("Captions done!");
      setState(() {
        _savedCaptions = allRows;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
