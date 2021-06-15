import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/providers/store_orders_provider.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/screens/storemanager/order_status_change_screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool loading = true;
  String storeId;

  List<String> _orderStatus = [
    "Pending",
    "Ready",
    "Completed",
  ];
  String _status = "Pending";
  getAndSetPendingOrders() async {
    storeId = Provider.of<StoreProvider>(context, listen: false).store.storeId;
    await Provider.of<StoreOrdersProvider>(context, listen: false)
        .getStatusOrder(storeId: storeId, orderStatus: "Pending");
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndSetPendingOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Orders",
          style: TextStyle(color: Colors.black87),
        ).tr(),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              child: Card(
                shape:
                    Border(right: BorderSide(color: kPrimaryColor, width: 7)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  height: 100,
                  // color: Colors.red,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Text(
                              "Choose status",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ).tr(),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: DropdownButton<String>(
                          iconEnabledColor: Colors.grey.withOpacity(.6),
                          isExpanded: true,
                          itemHeight: 50,
                          iconSize: 30,
                          hint: Text("Choose a status").tr(),
                          items: _orderStatus
                              .map((e) => DropdownMenuItem(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          value: _status,
                          onChanged: (String value) async {
                            setState(() {
                              _status = value;
                              loading = true;
                            });
                            await Provider.of<StoreOrdersProvider>(context,
                                    listen: false)
                                .getStatusOrder(
                                    storeId: storeId, orderStatus: value);
                            setState(() {
                              loading = false;
                            });
                          },
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          await Provider.of<StoreOrdersProvider>(context,
                                  listen: false)
                              .getStatusOrder(
                                  storeId: storeId, orderStatus: _status);
                        },
                        child: ListView(
                          children: [
                            ...Provider.of<StoreOrdersProvider>(context)
                                .storeOrderList
                                .map((order) => StoreOrderWidget(
                                      order: order,
                                      storeId: storeId,
                                    ))
                                .toList(),
                            if (Provider.of<StoreOrdersProvider>(context)
                                    .storeOrderList
                                    .length ==
                                0)
                              Center(
                                child: Text("There are no required orders yet")
                                    .tr(),
                              )
                          ],
                        ),
                      ))
          ],
        ),
      ),
    );
  }
}

class StoreOrderWidget extends StatelessWidget {
  StoreOrderListModel order;
  final String storeId;
  StoreOrderWidget({this.order, this.storeId});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => OrderStatusChangeScreen(
                  orderId: order.orderId,
                  currentStatus: order.orderStatus,
                  storeId: storeId,
                )));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(13),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Order",
                  style: TextStyle(color: Colors.black, fontSize: 19),
                ).tr(),
                Text(
                  "  ${order.orderId}",
                  style: TextStyle(color: Colors.black, fontSize: 19),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Placed on",
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  " ${order.orderDate}",
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  "  ${order.orderTime}",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Address",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ).tr(),
                Text(
                  "  ${order.address}",
                  style: TextStyle(fontSize: 17, color: Colors.black54),
                )
              ],
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Text("Status").tr(),
            //     ),
            //     Expanded(
            //       child: Text(order['orderStatus']),
            //     )
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  order.orderStatus,
                  style: TextStyle(
                      fontSize: 18,
                      color: order.orderStatus == 'Completed'
                          ? Colors.lightGreen
                          : order.orderStatus == 'Pending'
                              ? Colors.yellowAccent
                              : Colors.orange),
                ),
                Expanded(child: Container()),
                Text(
                  "Total".tr(),
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  ": ",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  "€${order.orderAmount}",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
