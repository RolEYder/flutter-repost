// @dart=2.0
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

gettingUserPurchaseInformation() async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();
    sharedPreferences.setString(
        "user_purchase_information", purchaserInfo.toJson().toString());
    print(purchaserInfo.toJson());
    // access latest purchaserInfo
  } on PlatformException catch (e) {
    // Error fetching purchaser info
    print(e);
  }
}

Future<bool> checkIfUserHasActivePurchase() async {
  try {
    CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (!purchaserInfo.entitlements.active.isEmpty) {
      //user has access to some entitlement
      if (purchaserInfo.entitlements.all["good_discount"].isActive) {
        // Good discount
        sharedPreferences.setString("subscription", "good_discount");
        return true;
      } else if (purchaserInfo.entitlements.all["best_offer"].isActive) {
        // Best Offer
        sharedPreferences.setString("subscription", "best_offer");
        return true;
      }
    } else {
      return false;
    }
  } on PlatformException catch (e) {
    print(e);
  }
}

gettingOfferingPurchaseProductos() async {
  try {
    Offerings offerings = await Purchases.getOfferings();
    if (offerings.current != null &&
        offerings.current.availablePackages.isNotEmpty) {
      // Display packages for sale
    }
  } on PlatformException catch (e) {
    // optional error handling
    print(e);
  }
}
