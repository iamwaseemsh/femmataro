import 'package:flutter/cupertino.dart';
import 'package:spain_project/models/trash_product_model.dart';
import 'package:spain_project/utils/utilities.dart';

class TrashProvider extends ChangeNotifier {
  List<TrashProductModel> _trashProductsList = [];
  List<TrashProductModel> get trashProductsList => _trashProductsList;

  Future getAndSetTrashProductList(String storeId) async {
    _trashProductsList = [];
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}trashProList.php",
        form: {"storeId": storeId});
    for (var item in response['productsList']) {
      _trashProductsList.add(TrashProductModel(
        proPrice: item['proPrice'].toString(),
        proCatName: item['proCatName'],
        proId: item['proId'],
        proName: item['proName'],
      ));
    }
    notifyListeners();
  }

  Future setPreTrashProducts(final list) async {
    _trashProductsList = [];

    for (var item in list) {
      _trashProductsList.add(TrashProductModel(
        proPrice: item['proPrice'].toString(),
        proCatName: item['proCatName'],
        proId: item['proId'],
        proName: item['proName'],
      ));
    }
    notifyListeners();
  }

  Future deleteTrashProduct(String proId, String storeId) async {
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}deleteProduct.php", form: {"proId": proId});
    await getAndSetTrashProductList(storeId);
  }

  Future restoreTrashProduct(String proId, String storeId) async {
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}restoreProduct.php", form: {"proId": proId});
    await getAndSetTrashProductList(storeId);
  }
}
