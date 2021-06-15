import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/utils/shared_pref_services.dart';
import 'package:spain_project/utils/utilities.dart';

import 'customer_order_details_screen.dart';

class CustomerOrderScreen extends StatefulWidget {
  @override
  _CustomerOrderScreenState createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  bool loading = true;
  var ordersList = [];
  getAndSetOrders() async {
    Utilities.showLoading();
    final user = await SharedPrefServices.getCurrentUser();
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}userOrderList.php",
        form: {"userEmail": user['email']});

    setState(() {
      ordersList = response['ordersList'];
    });
    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: .4,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "My Orders",
          style: TextStyle(color: Colors.black),
        ).tr(),
      ),
      body: Container(
        child: ListView(
          children: [
            ...ordersList
                .map((order) => CustomerOrderWidget(order, getAndSetOrders))
                .toList()
                .reversed
          ],
        ),
      ),
    );
  }
}

class CustomerOrderWidget extends StatelessWidget {
  Map order;
  final Function getAndSetOrders;
  CustomerOrderWidget(this.order, this.getAndSetOrders);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final canRefresh = await Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => CustomerOrderDetailsScreen(
                  orderId: order['orderId'],
                )));
        Logger().w(canRefresh);
        if (canRefresh == true) {
          getAndSetOrders();
        }
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
                  "  ${order['orderId']}",
                  style: TextStyle(color: Colors.black, fontSize: 19),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Placed on".tr(),
                  style: TextStyle(color: Colors.black54),
                ),
                Text(
                  " ${order['orderDate']}",
                  style: TextStyle(color: Colors.black54),
                )
              ],
            ),
            Row(
              children: [
                Text(
                  "Address",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ).tr(),
                Text(
                  "  ${order['address']}",
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
                  order['orderStatus'],
                  style: TextStyle(
                      fontSize: 18,
                      color: order['orderStatus'] == 'Pending'
                          ? Colors.orange
                          : kNotifcationGreenColor),
                ),
                Expanded(child: Container()),
                Text(
                  "Total",
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
                  "€${order['orderAmount']}",
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
