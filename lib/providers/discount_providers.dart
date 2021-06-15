import 'package:flutter/material.dart';
import 'package:spain_project/models/discount_model.dart';
import 'package:spain_project/utils/utilities.dart';

class DiscountProvider extends ChangeNotifier {
  List<DiscountModel> _discountList = [];

  List<DiscountModel> get discountList => _discountList;

  Future getAndSetDiscount(String store) async {
    _discountList = [];
    final url = "${Utilities.baseUrl}discountList.php";
    final result =
        await Utilities.getPostRequestData(url: url, form: {"storeId": store});

    for (var item in result['DiscountList']) {
      var date;
      if (item['discountExpiry'].length == 1) {
        date = '';
      } else {
        var dateParse = DateTime.parse(item['discountExpiry']);
        date = '${dateParse.year}-${dateParse.month}-${dateParse.day}';
      }

      _discountList.add(DiscountModel(
          discountCode: item['discountCode'],
          discountPercent: item['discountPercent'].toString(),
          discountExpiry: date,
          discountId: item['discountId']));
    }

    notifyListeners();
  }

  Future addDiscount(Map discount) async {
    // _storesList.add(store);
    String url = "${Utilities.baseUrl}addDiscount.php";
    final response = await Utilities.getPostRequestData(
      url: url,
      form: discount,
    );
    //i need discount id in response'
    var dateParse = DateTime.parse(discount['discountExpiry']);

    _discountList.add(DiscountModel(
        discountId: response['discountId'],
        discountCode: discount['discountCode'],
        discountExpiry: '${dateParse.year}-${dateParse.month}-${dateParse.day}',
        discountPercent: discount['discountPercent'].toString()));
    notifyListeners();
  }

  Future updateDiscount(Map discount) async {
    String url = "${Utilities.baseUrl}updateDiscounts.php";
    var dateParse = DateTime.parse(discount['discountExpiry']);
    _discountList = _discountList.map((item) {
      if (item.discountId == discount['discountId']) {
        return DiscountModel(
            discountCode: discount['discountCode'],
            discountPercent: discount['discountPercent'].toString(),
            discountExpiry:
                '${dateParse.year}-${dateParse.month}-${dateParse.day}',
            discountId: discount['discountId']);
      } else {
        return item;
      }
    }).toList();
    notifyListeners();
  }

  bool ifDiscountCodeAlreadyExists(String discountCode) {
    final list = discountList
        .where((element) => element.discountCode.toLowerCase() == discountCode)
        .toList();
    if (list.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteDiscount(String discountId, String storeId) async {
    final response = await Utilities.getPostRequestData(
        form: {"discountId": discountId, "storeId": storeId},
        url: "${Utilities.baseUrl}deleteDiscount.php");
    // _discountList=discountList.where((element) => element.discountId!=discountId).toList();
    print(response);
    await getAndSetDiscount(storeId);
    notifyListeners();
  }

  Future setPreDisocunt(final list) async {
    _discountList = [];

    for (var item in list) {
      var date;
      if (item['discountExpiry'].length == 1) {
        date = '';
      } else {
        var dateParse = DateTime.parse(item['discountExpiry']);
        date = '${dateParse.year}-${dateParse.month}-${dateParse.day}';
      }

      _discountList.add(DiscountModel(
          discountCode: item['discountCode'],
          discountPercent: item['discountPercent'].toString(),
          discountExpiry: date,
          discountId: item['discountId']));
    }

    notifyListeners();
  }
}
