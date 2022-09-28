// @dart=2.9

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:repost/dashboard.dart';
import 'package:repost/l10n/l10n.dart';
import 'package:repost/provider/locale_provider.dart';
import 'package:repost/screens/onboarding/onboarding_page.dart';
import 'package:repost/services/purchase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final _configuration =
    PurchasesConfiguration('appl_EfjAGDblTeCDGccRDhqThHQsiTN');
int initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await Purchases.configure(_configuration);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  void initializationSettingsApp() async {
    gettingUserPurchaseInformation();
    checkIfUserHasActivePurchase();
    if (initScreen == 0 || initScreen == null) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool("notification", false);
      await preferences.setBool('history', true);
      await preferences.setString("subscription", "free");
      await preferences.setString("language", "us");
      await preferences.setBool("isLoggedInstagram", false);
    }
  }

  @override
  void initState() {
    super.initState();
    initializationSettingsApp();
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LocaleProvider(),
        builder: (context, child) {
          final provider = Provider.of<LocaleProvider>(context); 
          return MaterialApp(
            theme: ThemeData(
                textTheme: const TextTheme(
                    bodySmall: TextStyle(fontSize: 16, color: Colors.white),
                    bodyLarge: TextStyle(fontSize: 24, color: Colors.white))),
            debugShowCheckedModeBanner: false,
            locale: provider.locale,
            supportedLocales: L10n.all,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            home: (initScreen == 0 || initScreen == null)
                ? OnboardingPage()
                : DashBoard(),
          );
        });
  }
}
