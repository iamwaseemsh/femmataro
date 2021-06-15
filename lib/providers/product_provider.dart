import 'package:flutter/cupertino.dart';
import 'package:spain_project/models/customer/offers_list_models.dart';
import 'package:spain_project/utils/utilities.dart';

class ProductProvider extends ChangeNotifier {
  List<OfferProductModel> _productList = [];
  List<OfferProductModel> get productList => _productList;

  Future getAndSetProducts(String proCatId) async {
    _productList = [];

    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}returnProductsAsStoreCat.php",
        form: {"proCatId": proCatId});

    for (var item in response['productsList']) {
      _productList.add(OfferProductModel(
          proPrice: item['proPrice'].toString(),
          proId: item['proId'].toString(),
          proImg: item['proImg'],
          storeName: item['storeName'],
          discountPercent: item['discountPercent'].toString(),
          proName: item['proName'],
          storeId: item['storeId']));
    }
    notifyListeners();
  }
}
