import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spain_project/models/new_product_image_model.dart';
import 'package:spain_project/models/product_category_model.dart';
import 'package:spain_project/models/store_product_model.dart';
import 'package:spain_project/screens/storemanager/profile_options_screens/faqs_screen.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:uuid/uuid.dart';

final dio = Dio();

class StoreProductProvider extends ChangeNotifier {
  List<StoreProductModel> _storeProductList = [];
  List<FaqsModel> _faqsList = [];
  List<FaqsModel> get faqsList => _faqsList;
  List<ProductCategoryModel> _productCategoriesList = [];
  List<ProductCategoryModel> get productCategoriestList =>
      _productCategoriesList;
  List<StoreProductModel> get storeProductList => _storeProductList;

  Future getAndSetCategoreis(String storeCatId) async {
    _productCategoriesList = [];
    final String url = "${Utilities.baseUrl}proCatList.php";
    final response = await Utilities.getPostRequestData(
        url: url, form: {"storeCatId": storeCatId});
    for (var item in response['proCatList']) {
      _productCategoriesList.add(ProductCategoryModel(
          proCatId: item['proCatId'], proCatName: item['proCatName']));
    }
    notifyListeners();
  }

  Future uploadnewProduct(
      {String name,
      String catId,
      String price,
      String description,
      String offerId,
      List<NewProductImageModel> files,
      String storeId}) async {
    String img1Name = "${Uuid().v4()}.${files[0].image.path.split('.').last}";
    String img2Name = "${Uuid().v4()}.${files[1].image.path.split('.').last}";
    String img3Name = "${Uuid().v4()}.${files[2].image.path.split('.').last}";
    String img4Name = "${Uuid().v4()}.${files[3].image.path.split('.').last}";
    String img5Name = "${Uuid().v4()}.${files[4].image.path.split('.').last}";

    FormData formData = FormData.fromMap({
      "storeId": storeId,
      'proName': name,
      'discountId': offerId,
      'proDesc': description,
      'proPrice': price,
      'proCatId': catId,
      "img1":
          await MultipartFile.fromFile(files[0].image.path, filename: img1Name),
      "img2":
          await MultipartFile.fromFile(files[1].image.path, filename: img2Name),
      "img3":
          await MultipartFile.fromFile(files[2].image.path, filename: img3Name),
      "img4":
          await MultipartFile.fromFile(files[3].image.path, filename: img4Name),
      "img5":
          await MultipartFile.fromFile(files[4].image.path, filename: img5Name),
      "ifImg1": files[0].ifImg == true ? 1 : 0,
      "ifImg2": files[1].ifImg == true ? 1 : 0,
      "ifImg3": files[2].ifImg == true ? 1 : 0,
      "ifImg4": files[3].ifImg == true ? 1 : 0,
      "ifImg5": files[4].ifImg == true ? 1 : 0,
    });
    print(formData.fields);
    final response =
        await dio.post("${Utilities.baseUrl}addProduct.php", data: formData);
    Logger().v(response.data);
    final result = jsonDecode(response.data);
    if (result['message'] != 'Found') await getAndSetProductList(storeId);
    // if(result['proId']!=null){
    //   _storeProductList.add(StoreProductModel(
    //       proId: result['proId'],
    //       proCatName: name,ss
    //       proImg: item['proImg'],
    //       proName: item['proName'],
    //       proPrice: item['proPrice'],
    //       discountPercent: item['discountPercent'],
    //       discountExpiry: item['discountExpiry']
    //   ));
    // }
    notifyListeners();

    return result;
  }

  Future updateAnProduct(
      {String name,
      String catId,
      String price,
      String description,
      String offerId,
      List<NewProductImageModel> files,
      String storeId,
      String proId,
      List<String> oldImages}) async {
    String img1Name = "${Uuid().v4()}.${files[0].image.path.split('.').last}";
    String img2Name = "${Uuid().v4()}.${files[1].image.path.split('.').last}";
    String img3Name = "${Uuid().v4()}.${files[2].image.path.split('.').last}";
    String img4Name = "${Uuid().v4()}.${files[3].image.path.split('.').last}";
    String img5Name = "${Uuid().v4()}.${files[4].image.path.split('.').last}";

    FormData formData = FormData.fromMap({
      "storeId": storeId,
      'proName': name,
      'discountId': offerId,
      'proDesc': description,
      'proPrice': price,
      'proCatId': catId,
      'proId': proId,
      "img1":
          await MultipartFile.fromFile(files[0].image.path, filename: img1Name),
      "img2":
          await MultipartFile.fromFile(files[1].image.path, filename: img2Name),
      "img3":
          await MultipartFile.fromFile(files[2].image.path, filename: img3Name),
      "img4":
          await MultipartFile.fromFile(files[3].image.path, filename: img4Name),
      "img5":
          await MultipartFile.fromFile(files[4].image.path, filename: img5Name),
      "ifImg1": files[0].ifImg == true ? 1 : oldImages[0],
      "ifImg2": files[1].ifImg == true ? 1 : oldImages[1],
      "ifImg3": files[2].ifImg == true ? 1 : oldImages[2],
      "ifImg4": files[3].ifImg == true ? 1 : oldImages[3],
      "ifImg5": files[4].ifImg == true ? 1 : oldImages[4],
    });

    final response =
        await dio.post("${Utilities.baseUrl}updateProduct.php", data: formData);
    print("bye");
    await getAndSetProductList(storeId);
    final result = jsonDecode(response.data);
    Logger().v(result);
    // if(result['proId']!=null){
    //   _storeProductList.add(StoreProductModel(
    //       proId: result['proId'],
    //       proCatName: name,
    //       proImg: item['proImg'],
    //       proName: item['proName'],
    //       proPrice: item['proPrice'],
    //       discountPercent: item['discountPercent'],
    //       discountExpiry: item['discountExpiry']
    //   ));
    // }
    notifyListeners();

    return result;
  }

  Future getAndSetProductList(String storeId) async {
    _storeProductList = [];
    String url = '${Utilities.baseUrl}productList.php';
    final response = await Utilities.getPostRequestData(
        url: url, form: {"storeId": storeId});
    for (var item in response["productsList"]) {
      _storeProductList.add(StoreProductModel(
          proId: item['proId'],
          proCatName: item['proCatName'],
          proImg: item['proImg'],
          proName: item['proName'],
          proPrice: item['proPrice'].toString(),
          discountPercent: item['discountPercent'].toString(),
          discountExpiry: item['discountExpiry']));
    }
    notifyListeners();
  }

  Future getAndSetFaqsList() async {
    _faqsList = [];
    String url = '${Utilities.baseUrl}faqs.php';
    final response = await Utilities.getGetRequestData(url);
    for (var item in response['FAQS']) {
      _faqsList
          .add(FaqsModel(question: item['question'], answer: item['answer']));
    }
  }

  Future deleteProduct(String proId, String storeId) async {
    String url = '${Utilities.baseUrl}trashProduct.php';
    final response =
        await Utilities.getPostRequestData(url: url, form: {"proId": proId});
    await getAndSetProductList(storeId);
    // if(response['message']==true){
    // }
  }

  setPreFaqList(final list) async {
    _faqsList = [];
    for (var item in list) {
      _faqsList
          .add(FaqsModel(question: item['question'], answer: item['answer']));
    }
  }

  Future setPreProductsList(final list) async {
    _storeProductList = [];
    for (var item in list) {
      _storeProductList.add(StoreProductModel(
          proId: item['proId'],
          proCatName: item['proCatName'],
          proImg: item['proImg'],
          proName: item['proName'],
          proPrice: item['proPrice'].toString(),
          discountPercent: item['discountPercent'].toString(),
          discountExpiry: item['discountExpiry']));
    }
    notifyListeners();
  }

  Future setPreProCats(final list) async {
    _productCategoriesList = [];
    for (var item in list) {
      _productCategoriesList.add(ProductCategoryModel(
          proCatId: item['proCatId'], proCatName: item['proCatName']));
    }
    notifyListeners();
  }
}
