import 'package:flutter/material.dart';
import 'package:spain_project/models/address_model.dart';
import 'package:spain_project/models/payment_info_model.dart';
import 'package:spain_project/models/store_model.dart';
import 'package:spain_project/networking/store.dart';

class StoreProvider extends ChangeNotifier {
  List<StoreModel> _storesList = [];
  StoreModel _store;
  AddressModel storeAdress;
  PaymentInfoModel storePaymentInfo;
  List<StoreModel> get storeList => _storesList;
  StoreModel get store => _store;
  setStore(StoreModel value) {
    _store = value;
  }

  setStoreAddress(AddressModel value) {
    storeAdress = value;
    notifyListeners();
  }

  setStorePayment(PaymentInfoModel value) {
    storePaymentInfo = value;
    notifyListeners();
  }

  updateStoreAddress(AddressModel value) {
    storeAdress = value;
    notifyListeners();
  }

  updateStorePayment(PaymentInfoModel value) {
    storePaymentInfo = value;
    notifyListeners();
  }

  Future getAndSetStores() async {
    _storesList = [];
    final result = await StoreServices.getStoreList();
    for (var item in result['storesList']) {
      _storesList.add(
        StoreModel(
            storeId: item['storeId'],
            storeName: item['storeName'],
            storeAddress: item['storeAddress'],
            storeCatId: item['storeCatId'],
            pendingOrders: item['pendingOrders'].toString()),
      );
    }

    notifyListeners();
  }

  Future addStore(StoreModel store) async {
    _storesList.add(store);
    notifyListeners();
  }
}
