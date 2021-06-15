import 'package:flutter/cupertino.dart';

class BillsProvider extends ChangeNotifier {
  List<BillsHistoryModel> billsHistoryList = [];
  List<SalesHistoryModel> salesHistoryList = [];
  List<StatModel> statsList = [];
  String totalSales;
  setBills(var items) async {
    billsHistoryList = [];
    for (var item in items) {
      billsHistoryList.add(
          BillsHistoryModel(text: item['payMonth'], amount: item['payment']));
    }
    notifyListeners();
  }

  setPreBills(final list) async {
    billsHistoryList = [];
    for (var item in list) {
      billsHistoryList.add(
          BillsHistoryModel(text: item['payMonth'], amount: item['payment']));
    }
    notifyListeners();
  }

  setHistoryList(var items) async {
    salesHistoryList = [];
    for (var item in items) {
      salesHistoryList.add(SalesHistoryModel(
          orderId: item['orderId'], amount: item['orderAmount']));
    }

    notifyListeners();
  }

  setPreHistoryList(final list) async {
    salesHistoryList = [];
    for (var item in list) {
      salesHistoryList.add(SalesHistoryModel(
          orderId: item['orderId'], amount: item['orderAmount']));
    }

    notifyListeners();
  }

  setStatList(var items) async {
    statsList = [];
    for (var item in items) {
      statsList.add(StatModel(
          monthName: item['monthName'],
          totalSale: item['totalSale'].toString()));
    }
    notifyListeners();
  }

  setPreStatList(final list) async {
    statsList = [];
    for (var item in list) {
      statsList.add(StatModel(
          monthName: item['monthName'],
          totalSale: item['totalSale'].toString()));
    }
    notifyListeners();
  }

  setTotalSale(String value) {
    totalSales = value;
    notifyListeners();
  }
}

class BillsHistoryModel {
  final String text;
  final String amount;
  BillsHistoryModel({this.text, this.amount});
}

class SalesHistoryModel {
  final String orderId;
  final String amount;
  SalesHistoryModel({this.amount, this.orderId});
}

class StatModel {
  final String monthName;
  final String totalSale;
  StatModel({this.monthName, this.totalSale});
}
