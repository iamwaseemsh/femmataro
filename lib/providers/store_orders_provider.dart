import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:spain_project/utils/utilities.dart';

class StoreOrdersProvider extends ChangeNotifier {
  List<StoreOrderListModel> _storeOrdersList = [];
  List<StoreOrderListModel> get storeOrderList => _storeOrdersList;
  Future getStatusOrder({String storeId, String orderStatus}) async {
    _storeOrdersList = [];

    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}ordersListByStatus.php",
        form: {"storeId": storeId, "orderStatus": orderStatus});
    Logger().i(response);
    for (var item in response['ordersList']) {
      _storeOrdersList.add(StoreOrderListModel(
          orderStatus: item['orderStatus'],
          orderAmount: item['orderAmount'],
          orderTime: item['orderTime'],
          address: item['address'],
          orderId: item['orderId'],
          orderDate: item['orderDate']));
    }
    notifyListeners();
  }

  Future updateOrderStatus(
      {String orderId, String orderStatus, String storeId}) async {
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}changeOrderStatus.php",
        form: {"orderStatus": orderStatus, "orderId": orderId});
    Logger().i(response);
    await getStatusOrder(storeId: storeId, orderStatus: orderStatus);
  }
}

class StoreOrderListModel {
  final String orderId;
  final String orderAmount;
  final String orderStatus;
  final String address;
  final String orderDate;
  final String orderTime;
  StoreOrderListModel(
      {this.address,
      this.orderId,
      this.orderStatus,
      this.orderAmount,
      this.orderTime,
      this.orderDate});
}
