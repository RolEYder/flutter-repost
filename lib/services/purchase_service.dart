// @dart=2.0
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

gettingUserPurchaseInformation() async {
  try {
    CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();

    // access latest purchaserInfo
  } on PlatformException catch (e) {
    // Error fetching purchaser info
    print(e);
  }
}

Future<bool> checkIfUserHasActivePurchase() async {
  try {
    CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();

    if (!purchaserInfo.entitlements.active.isEmpty) {
      //user has access to some entitlement
      if (purchaserInfo
          .entitlements.all["my_entitlement_identifier"].isActive) {
        // Grant user "pro" access
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
