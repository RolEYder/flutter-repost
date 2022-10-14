import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repost/l10n/l10n.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:repost/provider/locale_provider.dart';
import 'package:repost/screens/pro/proscreen.dart';
import 'package:repost/screens/repost/Screen/how_to_repost_screen.dart';
import 'package:repost/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notification = false;
  bool history = true;
  TextStyle HeaderStyle = TextStyle(
      color: Color.fromARGB(255, 114, 113, 113),
      fontSize: 18,
      fontWeight: FontWeight.bold);

  TextStyle insideStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  Widget _space() {
    return Divider(
      thickness: 0.5,
      color: Colors.grey[100],
    );
  }

  Widget height() => SizedBox(
        height: 10,
      );

  var edgeGap = const EdgeInsets.only(left: 12, bottom: 2);

  @override
  void initState() {
    settingApp();
    super.initState();
  }

  void settingApp() async {
    var prefs = await SharedPreferences.getInstance();

    setState(() {
      history = prefs.getBool("history") as bool;
      notification = prefs.getBool("notification") as bool;
    });
  }

  void setNotification(value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("notification", value);
  }

  void setClearHistory(value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool("history", value);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/back.png")),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.subscribe_pro_account,
                      style: insideStyle,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
            _space(),
            height(),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => Wrap(
                      children: [
                        ...L10n.all.map((locale) {
                          final flag = L10n.getFlag(locale.languageCode);
                          return ListTile(
                            onTap: () {
                              final provider = Provider.of<LocaleProvider>(
                                  context,
                                  listen: false);
                              provider.setLocale(locale);
                              Navigator.pop(context);
                            },
                            title: Text('$flag'),
                          );
                        }),
                      ],
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.change_langauge,
                      style: insideStyle,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
            _space(),
            height(),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HowToRepostScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.how_to_repost,
                      style: insideStyle,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    )
                  ],
                ),
              ),
            ),
            _space(),
            height(),
            _space(),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 2, bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.allow_notification,
                    style: insideStyle,
                  ),
                  SizedBox(
                    height: 30,
                    child: Switch.adaptive(
                        activeColor: Colors.green,
                        inactiveTrackColor: Colors.grey,
                        value: notification,
                        onChanged: (_) {
                          setState(() {
                            notification = !notification;
                            setNotification(notification);
                          });
                        }),
                  )
                ],
              ),
            ),
            _space(),
            const SizedBox(
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 2),
              child: Text(
                AppLocalizations.of(context)!.account_settings,
                style: HeaderStyle,
              ),
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.my_account,
                    style: insideStyle,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (history) {
                      history = !history;
                      // clear current post history
                      DatabaseHelper.instance.cleanHistory();
                      setClearHistory(false);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: history ? 1.0 : 0.5,
                      child: Text(
                        AppLocalizations.of(context)!.clear_history,
                        style: insideStyle,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.restore_purchases,
                    style: insideStyle,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
            _space(),
            const SizedBox(
              height: 28,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, bottom: 2),
              child: Text(
                AppLocalizations.of(context)!.terms_and_policies,
                style: HeaderStyle,
              ),
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.terms_of_service,
                    style: insideStyle,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.privacy_policy,
                    style: insideStyle,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.give_feedback,
                    style: insideStyle,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
            _space(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.review_us,
                    style: insideStyle,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                ],
              ),
            ),
            _space(),
            const SizedBox(
              height: 28,
            ),
            _space(),
          ],
        ),
      ),
    );
  }
}
