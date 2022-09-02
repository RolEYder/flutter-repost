import 'dart:developer';
import 'package:flutter/material.dart';
import '../../../models/caption_model.dart';
import '../../../services/database_service.dart';

class EditingCustomCaption extends StatefulWidget {
  final String? title;
  final String? content;
  final int? id;
  const EditingCustomCaption({Key? key,  this.title,  this.content, this.id}) : super(key: key);

  @override
  State<EditingCustomCaption> createState() => _EditingCustomCaptionState();
}

class _EditingCustomCaptionState extends State<EditingCustomCaption> {
  final dbHelper = DatabaseHelper.instance;
  List<Captions> captions = [];
  String buttonText = "Close";
  String _content = "" ;
  String _title = "";
  List<Map<String, dynamic>> _savedCaptions = [];
  TextEditingController contentController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  void _showMessageInScaffold(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  @override
  void initState() {
    super.initState();
    contentController = new TextEditingController(text: widget.content);
    titleController = new TextEditingController(text: widget.title);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context, "back");
            },
            child: Image.asset("assets/back.png")),
        title: widget.title == "" ? Text("Inserting Custom Caption") : Text("Editing Custom Caption") ,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextField(
            controller: titleController,
            onChanged: (value) {
              setState(() {
                _title = value.toString();
              });
            },
            style: TextStyle(fontSize: 12, color: Colors.white),
            decoration: InputDecoration(
                focusColor: Colors.grey,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                hintText: "Enter Custom Title",

                contentPadding: EdgeInsets.only(left: 10)),
          ),
          TextField(
            controller: contentController,
            onChanged: (value) {
              setState(() {
                _content = value.toString();
              });
            },
            style: TextStyle(fontSize: 12, color: Colors.white),
            decoration: InputDecoration(
                focusColor: Colors.grey,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                hintText: "Enter Custom Caption",
                contentPadding: EdgeInsets.only(left: 10)),
          ),

          Column(
            children: [
             if (widget.title == "") Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 125, 64, 121)),
                    onPressed: () {},
                    child: const Text(
                      "Insert Original\nUsername",
                      textAlign: TextAlign.center,
                    )),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 125, 64, 121)),
                    onPressed: () {},
                    child: const Text(
                      "Insert Original\nCaption",
                      textAlign: TextAlign.center,
                    )),
              )
            ],
          ) else SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(left: 68, right: 68),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 73, 65, 125)),
                        onPressed: () {
                          String content = contentController.text;
                          String title = titleController.text;
                          if (content
                              .toString()
                              .isNotEmpty && title.toString().isNotEmpty) {
                            if (widget.title == "" && widget.content == "") {
                              _insert(title, content); // inserting caption
                              Navigator.pop(context, "save"); // unmound widget
                            }
                            else if (widget.title!.isNotEmpty && widget.content!.isNotEmpty) {
                              // update
                              _update(title, content, widget.id);
                              Navigator.pop(context, "update");
                            }
                          }
                        },
                        child: (widget.title != "") ? Text("Update") : Text("Save"))),
              ),
              SizedBox(
                height: 10,
              )
            ],
          )
        ],
      ),
    );
  }

  void _update(title, content, Id) async {
    Map<String, dynamic> row = {DatabaseHelper.columnContent: content, DatabaseHelper.columnTitle: title, DatabaseHelper.columnId: Id};
    Captions caption = Captions.fromMap(row) ;
    final id = DatabaseHelper.instance.update(caption);
    _showMessageInScaffold("Caption was updated 👍 ");
  }
  void _insert(title, content) async {
    Map<String, dynamic> row = {DatabaseHelper.columnContent: content, DatabaseHelper.columnTitle: title};
    Captions caption = Captions.fromMap(row) ;
    final id = DatabaseHelper.instance.insert(caption);
    _showMessageInScaffold("Caption was inserted 👍 ");
  }
}
