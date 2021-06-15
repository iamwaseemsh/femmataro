import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:spain_project/models/customer/offers_list_models.dart';
import 'package:spain_project/utils/shared_pref_services.dart';
import 'package:spain_project/utils/utilities.dart';

class CustomerOffersProvider extends ChangeNotifier {
  List<String> storeBanners = [];
  List<OfferProductModel> _offersList = [];
  List<OfferProductModel> get offersList => _offersList;
  List<ProductCategoryModel> _productCategoryList = [];
  List<ProductCategoryModel> get productCategoryList => _productCategoryList;
  List<StoreCategoryModel> _storeCategoryList = [];

  List<StoreCategoryModel> get storeCategoryList => _storeCategoryList;

  bool userLocationStatusValue = false;
  Future userLocationStatus(String email) async {
    final user = await SharedPrefServices.getCurrentUser();
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}checkUserLocation.php",
        form: {"userEmail": email});
    if (response['message'] == true) {
      userLocationStatusValue = true;
    }
    notifyListeners();
  }

  setHomeSearchItems(var list) {
    _offersList = [];
    for (var item in list) {
      _offersList.add(OfferProductModel(
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

  Future getAndSetHomeData() async {
    storeBanners = [];
    _offersList = [];
    _storeCategoryList = [];
    final response = await Utilities.getPostRequestData(
        url: '${Utilities.baseUrl}offersList.php', form: {});
    for (var item in response['bannerImgs']) {
      storeBanners.add(item['bannerImg']);
    }
    for (var item in response['storeCatImgs']) {
      _storeCategoryList.add(StoreCategoryModel(
          storeCatImg: item['storeCatImg'],
          storeCatName: item['storeCatName'],
          storeCatId: item['storeCatId']));
    }
    for (var item in response['products']) {
      _offersList.add(OfferProductModel(
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

  Future setStoreCategories() async {
    _storeCategoryList = [];

    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}returnStoreCats.php", form: {});

    for (var item in response['storeCats']) {
      _storeCategoryList.add(StoreCategoryModel(
          storeCatName: item['storeCatName'] ?? 'Undefined',
          storeCatImg: item['storeCatImg'],
          storeCatId: item['storeCatId'].toString()));
    }

    notifyListeners();
  }

  Future setProductCategories(String storeCatId) async {
    _productCategoryList = [];
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}returnStoresAsStoreCat.php",
        form: {
          "storeCatId": storeCatId,
          'language': Utilities.currentLangauge
        });
    Logger().i(response);
    for (var item in response['proCats']) {
      _productCategoryList.add(ProductCategoryModel(
        proCatName: item['proCatName'],
        proCatId: item['proCatId'],
        proCatImgUrl: item['proCatImg'],
      ));
    }
    notifyListeners();
  }

  Future setCustomProducts(final products) {
    Logger().i(products);
    _offersList = [];

    for (var item in products['productsList']) {
      _offersList.add(OfferProductModel(
          storeName: item['storeName'],
          storeId: item['storeId'],
          proPrice: item['proPrice'].toString(),
          proImg: item['proImg'],
          proName: item['proName'],
          discountPercent: item['discountPercent'].toString(),
          proId: item['proId']));
    }
    notifyListeners();
  }

  Future setAllProducts() async {
    _offersList = [];
    final response = await Utilities.getGetRequestData(
        '${Utilities.baseUrl}seeAllProducts.php');
    Logger().i(response);

    for (var item in response['seeAllProducts']) {
      _offersList.add(OfferProductModel(
          storeName: item['storeName'].toString(),
          storeId: item['storeId'].toString(),
          proPrice: item['proPrice'].toString(),
          proImg: item['proImg'],
          proName: item['proName'],
          discountPercent: item['discountPercent'].toString(),
          proId: item['proId']));
    }
    notifyListeners();
  }

  Future setStoreCatProducts(String catId) async {
    _offersList = [];
    final response = await Utilities.getPostRequestData(
        url: '${Utilities.baseUrl}productsByCat.php', form: {"catId": catId});
    Logger().i(response);
    for (var item in response['productsByCat']) {
      _offersList.add(OfferProductModel(
          storeName: item['storeName'].toString(),
          storeId: item['storeId'].toString(),
          proPrice: item['proPrice'].toString(),
          proImg: item['proImg'],
          proName: item['proName'],
          discountPercent: item['discountPercent'].toString(),
          proId: item['proId']));
    }
    notifyListeners();
  }
}
