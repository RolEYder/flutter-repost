import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:repost/dashboard.dart';
import 'package:repost/helper/theme.dart';
import 'package:repost/screens/pro/paywall.dart';

import 'styles.dart';

class ProScreen extends StatefulWidget {
  const ProScreen({Key? key}) : super(key: key);

  @override
  State<ProScreen> createState() => _ProScreenState();
}

class _ProScreenState extends State<ProScreen> {
  int selectedTrial = -1;

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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashBoard()));
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
                      "Open up to incredible features in a  \n quick and easy manner.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              customcontainer("Unlimited reposts", "upgrade1.png"),
              const SizedBox(
                height: 10,
              ),
              customcontainer("Premium hastags", "upgrade2.png"),
              const SizedBox(
                height: 10,
              ),
              customcontainer("And may more features...", "upgrade3.png"),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customCard("Free", "1", "Week", "Free Trial", "trial.png", 0),
                  customCard("\$22.99", "6", "Months", "Best Offer",
                      "best_offer.png", 1),
                  customCard("\$4.99", "1", "Month", "Good Discount",
                      "good_discount.png", 2),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 49,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: primaryColor),
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
                      print(myProductList.length);
                      switch (selectedTrial) {
                        case 0:
                          try {
                            var purchaserInfo = await Purchases.purchasePackage(
                                myProductList[2]);
                            if (purchaserInfo
                                .entitlements.all["free_trial"]!.isActive) {
                              // Unlock that great "pro" content
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
                        case 1:
                          try {
                            var purchaserInfo = await Purchases.purchasePackage(
                                myProductList[0]);
                            if (purchaserInfo
                                .entitlements.all["good_discount"]!.isActive) {
                              // Unlock that great "pro" content
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
                            if (purchaserInfo
                                .entitlements.all["best_offer"]!.isActive) {
                              // Unlock that great "pro" content
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
                      // showModalBottomSheet(
                      //   useRootNavigator: true,
                      //   isDismissible: true,
                      //   isScrollControlled: true,
                      //   backgroundColor: kColorBackground,
                      //   shape: const RoundedRectangleBorder(
                      //     borderRadius:
                      //         BorderRadius.vertical(top: Radius.circular(25.0)),
                      //   ),
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return StatefulBuilder(builder: (BuildContext context,
                      //         StateSetter setModalState) {
                      //       return Paywall(
                      //         offering: offerings.current,
                      //       );
                      //     });
                      //   },
                      // );
                    },
                    child: const Text(
                      "Subscribe",
                      style: TextStyle(fontSize: 16),
                    )),
              )
            ],
          ),
        ));
  }
}
