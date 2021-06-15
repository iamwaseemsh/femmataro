import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:spain_project/utils/shared_pref_services.dart';
import 'package:spain_project/utils/utilities.dart';

class StoreServices {
  static Future getStoreList() async {
    final currentUser = await SharedPrefServices.getCurrentUser();
    String url = "${Utilities.baseUrl}returnStoresList.php";
    final response = await http.post(Uri.parse(url), body: {
      "userEmail": currentUser['email'],
    });
    return jsonDecode(response.body);
  }

  static Future isStorePaid(String storeId, String storeCatId) async {
    Logger().i(storeCatId);
    String url = '${Utilities.baseUrl}checkPayment.php';
    final response = await http.post(Uri.parse(url),
        body: {"storeId": storeId, "storeCatId": storeCatId});
    //storeProductList
    //Store Sales
    //store Notifications
    //store address
    //Payment method details
    //promotions
    //faqs
    //trashbin
    final result = jsonDecode(response.body);

    return result;
    // return jsonDecode(response.body);
  }
}
