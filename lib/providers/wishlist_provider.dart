import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:spain_project/models/customer/wishlist_item_model.dart';
import 'package:spain_project/utils/utilities.dart';

import '../utils/shared_pref_services.dart';

class WishListProvider extends ChangeNotifier {
  int isChanged = 0;
  List<WishListItemModel> wishListItems = [];
  List<String> sharedPrefWishList = [];
  Future addWishListItem(WishListItemModel item) async {
    Logger().i(item.proId);
    final user = await SharedPrefServices.getCurrentUser();

    if ((wishListItems.singleWhere((it) => it.proId == item.proId,
            orElse: () => null)) !=
        null) {
      sharedPrefWishList.remove(jsonEncode(item.toMap()));

      final response = await Utilities.getPostRequestData(
          url: "${Utilities.baseUrl}wishlist.php",
          form: {"userEmail": user['email'], "proId": item.proId.toString()});
      Logger().i("removed $response");
      // await SharedPrefServices.setListValue(
      //     name: 'wishlist', values: sharedPrefWishList);

      wishListItems
          .removeWhere((element) => element.proId == item.proId.toString());
    } else {
      wishListItems.add(item);
      // sharedPrefWishList.add(jsonEncode(item.toMap()));
      // await SharedPrefServices.setListValue(
      //     name: 'wishlist', values: sharedPrefWishList);

      final response = await Utilities.getPostRequestData(
          url: "${Utilities.baseUrl}wishlist.php",
          form: {"userEmail": user['email'], "proId": item.proId});
      Logger().i("Item added from wishlist ${response}");
      isChanged = 1;
    }
    notifyListeners();
  }

  setIsChanged() {
    isChanged = 0;
    notifyListeners();
  }

  Future getAndSetWishListFromPref(String email) async {
    // final response = await SharedPrefServices.getListValue(name: 'wishlist');

    final user = await SharedPrefServices.getCurrentUser();

    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}wishlistProducts.php",
        form: {"userEmail": email});

    for (var item in response['productsList']) {
      wishListItems.add(WishListItemModel(
          proImg: item['proImg'],
          proPrice: item['proPrice'].toString(),
          proDesc: item['proDesc'] ?? "",
          storeName: item['storeName'],
          storeId: item['storeId'],
          proId: item['proId'],
          discountPercent: item['discountPercent'].toString(),
          proName: item['proName']));
    }
  }

  bool checkIfItemExists(String id) {
    if ((wishListItems.singleWhere((it) => it.proId == id,
            orElse: () => null)) !=
        null) {
      return true;
      print('Already exists!');
    } else {
      print('Added!');
      return false;
    }
  }
}
