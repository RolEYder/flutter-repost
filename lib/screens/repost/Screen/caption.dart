import 'package:flutter/material.dart';
import 'package:repost/model/caption.dart';
import 'editing_custom_caption.dart';
import '../../../db/db_sqlite_helper.dart';
import 'dart:developer';
import '../../../model/caption.dart';

class Caption extends StatefulWidget {
  final String CustomCaption;
  const Caption({Key? key, required this.CustomCaption}) : super(key: key);
  @override
  State<Caption> createState() => _CaptionState();

}

class _CaptionState extends State<Caption> {
  bool rememberMe = false;
  final dbHelper = DatabaseHelper.instance;
  List<Captions> captions = [];
  bool _isLoading = false;
  late List<Map<String, dynamic>> _savedCaptions = [];
  List isCheckedbox = [];
  late List<dynamic> data = [
    {"title": "Custom", "description": "Choose to Edit"},
    {"title": "Original", "description": widget.CustomCaption.toString()}
  ];
  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
      _getALlCaptions();
    });
    setState(() {
      _isLoading = false;
    });
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
                  primary: const Color.fromARGB(255, 73, 65, 125)),
              onPressed: () {},
              child: Text("Save")),
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
        title: Text("Caption"),
      ),
      body: !_isLoading ? Padding(
        padding:  EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _savedCaptions.length == 0? 1 : _savedCaptions.length ,
          itemBuilder: ((context, index) {
            Map<String, dynamic>  item = _savedCaptions[index];
            return Dismissible(key: UniqueKey(), child: GestureDetector(
              onTap: () {
                _saveCaption(context, index);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _savedCaptions.isEmpty? " " : _savedCaptions[index]["title"],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                            _savedCaptions.isEmpty ? " " : _savedCaptions[index]["content"],
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isCheckedbox.contains(index)) {
                              isCheckedbox.remove(index);
                            } else {
                              isCheckedbox.add(index);
                            }
                          });
                        },
                        child: isCheckedbox.contains(index)
                            ? Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 0, 8, 239),
                          size: 22,
                        )
                            : Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                          width: 22,
                          height: 22,
                        ),
                      )
                    ],
                  ),
                  Text("#priceless #sofun",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Divider(
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            direction: DismissDirection.startToEnd,
            onDismissed: (DismissDirection dir) {
              List<Map<String, dynamic>> map = List<Map<String, dynamic>>.from(this._savedCaptions);
              map.removeAt(index);
              setState(() => {
               this._savedCaptions = map
              });
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(duration: const Duration(seconds: 3), content: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.error_outline, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(dir == DismissDirection.startToEnd ? '`${this._savedCaptions[index]["title"]}` removed' : '$index update'),
                      ),
                    ],
                  ),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      List<Map<String, dynamic>> map = List<Map<String, dynamic>>.from(this._savedCaptions);
                      map.insert(index, item);
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
               child: const Icon(Icons.delete)
             ),
             secondaryBackground: Container(
               color: Colors.green,
               alignment: Alignment.centerRight,
               child: const Icon(Icons.save),
             )
              ,);

          }),
        ),
      ) : const CircularProgressIndicator(),
    );
  }

  Future<void> _saveCaption(BuildContext context, int index) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditingCustomCaption(title: _savedCaptions[index]["title"].toString(),
        content: _savedCaptions[index]["content"].toString())));
    if (!mounted) return;
    // After the Selection Screen returns a result, hide any previous nackbars
    // and show the new result.
    if (result == "save") {
      _getALlCaptions();
    }
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('New caption added succesffuly 👍')));
  }


  void _getALlCaptions() async {
    final allRows = await dbHelper.getAllRows();
    log(allRows.toString());
    if (allRows.isNotEmpty) {
      log(allRows.toString());
      captions.clear();
      allRows.forEach((row) => captions.add(Captions.fromMap(row)));
      _showMessageInScaffold("Captions done!");
      setState(() {
        _savedCaptions = allRows;
      });
    }
    else {
     setState(() {
       _savedCaptions.add({"title": "Custom", "content": "Choose to Edit"});
     });
    }
  }
}

