import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 28, 28, 28),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12, bottom: 10),
            child: Text(
              AppLocalizations.of(context)!.more_useful_apps,
              style: TextStyle(
                  height: 0.95,
                  letterSpacing: 0,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12, top: 12, bottom: 10, right: 12),
            child: Text(AppLocalizations.of(context)!.get_more_apps,
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 79, 76, 76),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Container(
              // height: 130,
              child: Card(
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "assets/hastag.png",
                      fit: BoxFit.fill,
                    )),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Container(
              // height: 130,
              child: Card(
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "assets/sensex.png",
                      fit: BoxFit.fill,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
