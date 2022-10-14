// @dart=2.9

import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:repost/dashboard.dart';
import 'package:repost/l10n/l10n.dart';
import 'package:repost/models/push_notification_model.dart';
import 'package:repost/provider/locale_provider.dart';
import 'package:repost/screens/onboarding/onboarding_page.dart';
import 'package:repost/services/purchase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'notifications/notification_badge.dart';

final _configuration =
    PurchasesConfiguration('appl_EfjAGDblTeCDGccRDhqThHQsiTN');
int initScreen;

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

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
  void initializationNotificationSettingsApp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int _totalNotifications = 0;
    FirebaseMessaging _messaging;
    PushNotification _notificationInfo;
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(
        (_firebaseMessagingBackgroundHandler));
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String token = await _messaging.getToken();
      print("token is ${token}");
      print("User granted permission");
      prefs.setString("tokenDevice", token);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
            title: message.notification.title, body: message.notification.body);
        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        if (_notificationInfo != null) {
          showSimpleNotification(
            Text(_notificationInfo.title),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo.body),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    }
  }

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
      await preferences.setInt(
          'lastAccess', DateTime.now().millisecondsSinceEpoch);
      await preferences.setBool("isRated", false);
    }
  }

  @override
  void initState() {
    super.initState();
    initializationNotificationSettingsApp();
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
