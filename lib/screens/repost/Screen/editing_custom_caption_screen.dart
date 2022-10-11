import 'package:flutter/material.dart';
import 'package:repost/models/caption_model.dart';
import 'package:repost/services/database_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditingCustomCaption extends StatefulWidget {
  final String? title;
  final String? content;
  final int? id;
  final String? Username;
  final String? OriginalCaption;
  const EditingCustomCaption(
      {Key? key,
      this.Username,
      this.OriginalCaption,
      this.title,
      this.content,
      this.id})
      : super(key: key);

  @override
  State<EditingCustomCaption> createState() => _EditingCustomCaptionState();
}

class _EditingCustomCaptionState extends State<EditingCustomCaption> {
  final dbHelper = DatabaseHelper.instance;
  List<Captions> captions = [];
  String buttonText = "Close";
  // ignore: unused_field
  String _content = "";
  // ignore: unused_field
  String _title = "";
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
        title: widget.title == ""
            ? Text(AppLocalizations.of(context)!.inserting_custom_caption)
            : Text(AppLocalizations.of(context)!.updating_custom_caption),
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
                hintText: AppLocalizations.of(context)!.enter_custom_title,
                contentPadding: EdgeInsets.only(left: 10)),
          ),
          TextField(
            controller: contentController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onChanged: (value) {
              setState(() {
                _content = value.toString();
              });
            },
            style: TextStyle(fontSize: 12, color: Colors.white),
            decoration: InputDecoration(
                focusColor: Colors.grey,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                hintText: AppLocalizations.of(context)!.enter_custom_caption,
                contentPadding: EdgeInsets.only(left: 10)),
          ),
          Column(
            children: [
              if (widget.title == "")
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 125, 64, 121)),
                          onPressed: () {
                            contentController.text = contentController.text +
                                " " +
                                "@" +
                                widget.Username.toString();
                          },
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .insert_original_username,
                                textAlign: TextAlign.center,
                              ))),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 125, 64, 121)),
                          onPressed: () {
                            contentController.text = contentController.text +
                                " " +
                                widget.OriginalCaption.toString();
                            setState(() {});
                          },
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .insert_original_caption,
                                textAlign: TextAlign.center,
                              ))),
                    )
                  ],
                )
              else
                SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(left: 68, right: 68),
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 73, 65, 125)),
                        onPressed: () {
                          String content = contentController.text;
                          String title = titleController.text;
                          if (content.toString().isNotEmpty &&
                              title.toString().isNotEmpty) {
                            if (widget.title == "" && widget.content == "") {
                              _insert(title, content); // inserting caption

                            } else if (widget.title!.isNotEmpty &&
                                widget.content!.isNotEmpty) {
                              // update
                              _update(title, content, widget.id);
                              Navigator.pop(context, "update"); //unmount widget
                            }
                          }
                        },
                        child: (widget.title != "")
                            ? Text(AppLocalizations.of(context)!.update)
                            : Text(AppLocalizations.of(context)!.save))),
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
    Map<String, dynamic> row = {
      DatabaseHelper.columnContent: content,
      DatabaseHelper.columnTitle: title,
      DatabaseHelper.columnId: Id
    };
    Captions caption = Captions.fromMap(row);
    DatabaseHelper.instance.update_caption(caption);
    _showMessageInScaffold("Caption was updated 👍 ");
  }

  void _insert(title, content) async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnContent: content,
      DatabaseHelper.columnTitle: title
    };
    Captions caption = Captions.fromMap(row);
    DatabaseHelper.instance.insert(caption);
    Navigator.pop(context, "save"); // unmount widget
  }
}
