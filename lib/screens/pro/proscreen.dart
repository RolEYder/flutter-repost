import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:repost/dashboard.dart';
import 'package:repost/helper/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProScreen extends StatefulWidget {
  const ProScreen({Key? key}) : super(key: key);

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  int selectedTrial = -1;
  String _subscriptionType = "";

  Widget customCard(String header, String number, String weeks,
      String topHeading, String image, int indexNo) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTrial = indexNo;
        });
      },
      child: Container(
        child: Column(
          children: [
            Text(
              "$topHeading",
              style: TextStyle(color: Colors.blue),
            ),
            Card(
              color: selectedTrial == indexNo ? primaryColor : secondaryColor,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 18, right: 18),
                child: Column(
                  children: [
                    Text(
                      "$header",
                      style: TextStyle(
                          color: selectedTrial == indexNo
                              ? primaryTxtColor
                              : secondaryTxtColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                        width: 75,
                        height: 75,
                        child: Image.asset("assets/$image")),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      number,
                      style: TextStyle(
                          color: selectedTrial == indexNo
                              ? primaryTxtColor
                              : secondaryTxtColor,
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(weeks,
                        style: TextStyle(
                            color: selectedTrial == indexNo
                                ? primaryTxtColor
                                : secondaryTxtColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showMessageMembership(String subscription) {
    try {
      switch (subscription) {
        case "best_offer":
          return Text(
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            "You already are subscribed to BEST OFFER subscription. You should change you subscription plan if you wish. ",
            textAlign: TextAlign.center,
          );

        case "good_discount":
          return Text(
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            "You already are subscribed to GOOD DISCOUNT subscription. You should change you subscription plan if you wish.  ",
            textAlign: TextAlign.center,
          );
      }
    } catch (e) {
      throw e;
    }
    return SizedBox.shrink();
  }

  Widget customcontainer(String leading, String image) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 28, 28, 28),
      ),
      height: 55,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(leading, style: TextStyle(color: secondaryTxtColor)),
            Image.asset("assets/$image")
          ],
        ),
      ),
    );
  }

  TextStyle headerStyle =
      TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        getSubscriptionPurchaseUser();
      });
    }
  }

  void getSubscriptionPurchaseUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _subscriptionType = (sharedPreferences.getString("subscription")!);
    });
    //  _subscriptionType = "good_discount";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Container(
                height: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text("UPGRADE", style: headerStyle),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "TO A",
                          style: headerStyle,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(18)),
                              // color: Colors.blue,
                              width: 80,
                              height: 28,
                              child: Center(
                                child: Text(
                                  "PREMIUM",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primaryTxtColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 17,
                              right: -6,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.star,
                                  color: Color.fromARGB(255, 247, 186, 10),
                                  size: 16,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Text(
                      "MEMBERSHIP",
                      style: headerStyle,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .open_up_to_incredible_features,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              customcontainer(AppLocalizations.of(context)!.unlimited_repost,
                  "upgrade1.png"),
              const SizedBox(
                height: 10,
              ),
              customcontainer(AppLocalizations.of(context)!.premium_hashtags,
                  "upgrade2.png"),
              const SizedBox(
                height: 10,
              ),
              customcontainer(
                  AppLocalizations.of(context)!.and_many_more_features,
                  "upgrade3.png"),
              const SizedBox(
                height: 20,
              ),
              showMessageMembership(_subscriptionType),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customCard(
                      "\$4.99",
                      "1",
                      AppLocalizations.of(context)!.months,
                      AppLocalizations.of(context)!.basic,
                      "good_discount.png",
                      1),
                  customCard(
                      "\$22.99",
                      "6",
                      AppLocalizations.of(context)!.months,
                      AppLocalizations.of(context)!.good_discount,
                      "best_offer.png",
                      2),
                  customCard(
                      "\$44.99",
                      "1",
                      AppLocalizations.of(context)!.year,
                      AppLocalizations.of(context)!.best_offer,
                      "best_offer.png",
                      3),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 49,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: primaryColor),
                    onPressed: () async {
                      if (selectedTrial == -1) {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Unable to continue'),
                              content:
                                  const Text('You must select a offer before'),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                      Offerings offerings = await Purchases.getOfferings();
                      var myProductList = offerings.current!.availablePackages;

                      switch (selectedTrial) {
                        case 1:
                          try {
                            var purchaserInfo = await Purchases.purchasePackage(
                                myProductList[0]);
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                "subscription", "basic");
                            if (purchaserInfo
                                .entitlements.all["basic"]!.isActive) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashBoard()));
                            }
                          } on PlatformException catch (e) {
                            var errorCode =
                                PurchasesErrorHelper.getErrorCode(e);
                            if (errorCode !=
                                PurchasesErrorCode.purchaseCancelledError) {
                              print(e);
                            }
                          }
                          break;
                        case 2:
                          try {
                            var purchaserInfo = await Purchases.purchasePackage(
                                myProductList[1]);
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                "subscription", "good_discount");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard()));
                            if (purchaserInfo
                                .entitlements.all["good_discount"]!.isActive) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashBoard()));
                            }
                          } on PlatformException catch (e) {
                            var errorCode =
                                PurchasesErrorHelper.getErrorCode(e);
                            if (errorCode !=
                                PurchasesErrorCode.purchaseCancelledError) {
                              print(e);
                            }
                          }
                          break;
                        case 3:
                          try {
                            var purchaserInfo = await Purchases.purchasePackage(
                                myProductList[2]);
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                "subscription", "best_offer");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DashBoard()));
                            if (purchaserInfo
                                .entitlements.all["best_offer"]!.isActive) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashBoard()));
                            }
                          } on PlatformException catch (e) {
                            var errorCode =
                                PurchasesErrorHelper.getErrorCode(e);
                            if (errorCode !=
                                PurchasesErrorCode.purchaseCancelledError) {
                              print(e);
                            }
                          }
                          break;
                        default:
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.subscribe,
                      style: TextStyle(fontSize: 16),
                    )),
              )
            ],
          ),
        ));
  }
}
