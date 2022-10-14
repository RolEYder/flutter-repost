import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HowToRepostScreen extends StatefulWidget {
  const HowToRepostScreen({Key? key}) : super(key: key);

  @override
  _HowToRepostScreenState createState() => _HowToRepostScreenState();
}

class _HowToRepostScreenState extends State<HowToRepostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(AppLocalizations.of(context)!.how_to_repost),
        actions: [],
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.only(left: 12, top: 8),
        child: ListView(
          itemExtent: 50.0,
          shrinkWrap: true,
          children: <Widget>[
            ListTile(
              title: Text(
                '1. ' + AppLocalizations.of(context)!.open_instagram,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: Text(
                '2. ' + AppLocalizations.of(context)!.find_the_photo_or_video,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: Text(
                '3. ' + AppLocalizations.of(context)!.tap_button,
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: Text(
                '4. ' + AppLocalizations.of(context)!.return_to_repost,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
