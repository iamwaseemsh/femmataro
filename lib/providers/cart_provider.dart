import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import '../models/customer/cart_item_model.dart';
import '../utils/shared_pref_services.dart';

class CartProvider extends ChangeNotifier {
  List<CartItemModel> cartItemsList = [];
  List<String> sharedPrefCartItemsList = [];
  Future addCartItem(CartItemModel item) async {
    if ((cartItemsList.singleWhere((it) => it.proId == item.proId,
            orElse: () => null)) !=
        null) {
      await increateQty(proId: item.proId, qty: item.qty);
    } else {
      Logger().i("added");
      cartItemsList.add(item);
      await setSharedPrefCarts();
// sharedPrefCartItemsList.add(jsonEncode(item.toMap()));
    }
    notifyListeners();
  }

  Future removeCartItem(String proId) async {
    cartItemsList =
        cartItemsList.where((element) => element.proId != proId).toList();
    await setSharedPrefCarts();

    notifyListeners();
  }

  Future removeCartItemsByStoreId(String storeId) async {
    cartItemsList =
        cartItemsList.where((element) => element.storeId != storeId).toList();
    await setSharedPrefCarts();

    notifyListeners();
  }

  Future getAndSetCartItemsFromPref() async {
    final response =
        await SharedPrefServices.getListValue(name: 'cartItemsList');
    for (var item in response) {
      Map data = jsonDecode(item);
      addCartItem(CartItemModel(
          proImg: data['proImg'],
          proPrice: data['proPrice'],
          storeName: data['storeName'],
          storeId: data['storeId'],
          disoucntPercent: data['discountPercent'],
          proId: data['proId'],
          proName: data['proName'],
          qty: data['qty']));
    }
  }

  Future increateQty({String proId, int qty}) async {
    cartItemsList = cartItemsList.map((item) {
      if (item.proId == proId) {
        item.qty = item.qty + qty;
        return item;
      }
      return item;
    }).toList();
    await setSharedPrefCarts();
    notifyListeners();
  }

  Future decreaseQty({String proId}) async {
    cartItemsList = cartItemsList.map((item) {
      if (item.proId == proId) {
        item.qty = item.qty - 1;
        return item;
      }
      return item;
    }).toList();
    await setSharedPrefCarts();
    notifyListeners();
  }

  Future setSharedPrefCarts() async {
    sharedPrefCartItemsList = [];
    for (CartItemModel item in cartItemsList) {
      sharedPrefCartItemsList.add(jsonEncode(item.toMap()));
    }

    await SharedPrefServices.setListValue(
        name: 'cartItemsList', values: sharedPrefCartItemsList);
  }

  Future getAndSetItems() async {
    final response =
        await SharedPrefServices.getListValue(name: 'cartItemsList');

    for (var item in response) {
      Map data = jsonDecode(item);
      cartItemsList.add(CartItemModel(
          proImg: data['proImg'],
          proPrice: data['proPrice'],
          storeName: data['storeName'],
          storeId: data['storeId'],
          disoucntPercent: data['discountPercent'],
          proId: data['proId'],
          proName: data['proName'],
          qty: int.parse(data['qty'])));
    }
  }
}
