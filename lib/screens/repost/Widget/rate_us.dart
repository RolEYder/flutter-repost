import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> reteApplication(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final rate = sharedPreferences.getBool("isRated");
  final subs = sharedPreferences.getString("subscription");
  print(rate);
  if (rate == false && subs == "free") {
    final url = "https://appsserverinst.xyz/repot.php/";
    final response = await Dio().get(url);
    final data = json.decode(json.encode(response.data));
    print(data);
    Future<void> _launchUrl() async {
      if (!await launchUrl(Uri.parse(data["lin"]))) {
        throw 'Could not launch $data["lin"]';
      }
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.rate_us),
          content: Text(AppLocalizations.of(context)!.rate_our_application),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                  AppLocalizations.of(context)!.i_dont_want_at_this_moment),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(AppLocalizations.of(context)!.rate),
              onPressed: () async {
                sharedPreferences.setBool("isRated", true);
                _launchUrl();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
