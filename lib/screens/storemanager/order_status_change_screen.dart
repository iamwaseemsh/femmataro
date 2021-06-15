import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/providers/store_orders_provider.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/main_button.dart';

class OrderStatusChangeScreen extends StatefulWidget {
  String currentStatus;
  String orderId;
  String storeId;
  OrderStatusChangeScreen({this.currentStatus, this.orderId, this.storeId});
  @override
  _OrderStatusChangeScreenState createState() =>
      _OrderStatusChangeScreenState();
}

class _OrderStatusChangeScreenState extends State<OrderStatusChangeScreen> {
  DateTime selectedTimeFrom;
  DateTime selectedTimeTo;

  DateTime selectedDate;
  bool loading = true;
  String nextStatus;
  var response;
  getOrderDetails() async {
    response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}orderDetails.php",
        form: {"orderId": widget.orderId});

    Logger().i(response);

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.currentStatus == 'Pending') {
      nextStatus = "Ready";
    } else if (widget.currentStatus == 'Ready') {
      nextStatus = "Completed";
    }
    getOrderDetails();
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
          "Manage Order",
          style: TextStyle(color: Colors.black87),
        ).tr(),
        elevation: 0,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                      child: ListView(
                    children: [
                      Text(
                        "Order Details",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ).tr(),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text('Order ID').tr(),
                                  Text(": ${response['orderId']}")
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Order Amount').tr(),
                                  Text(": ${response['orderAmount']}")
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Postal Code').tr(),
                                  Text(": ${response['postalCode']}")
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Address').tr(),
                                  Expanded(
                                    child: Text(": ${response['address']}"),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Order Date').tr(),
                                  Text(": ${response['orderDate']}")
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Order Time').tr(),
                                  Text(": ${response['orderTime']}")
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Order Status').tr(),
                                  Text(": ${response['orderStatus']}")
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (response['orderStatus'] == 'Pending')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  var parsed =
                                      DateTime.parse(DateTime.now().toString());
                                  var newDate = new DateTime(
                                      parsed.year, parsed.month, parsed.day);
                                  DatePicker.showDatePicker(context,
                                      showTitleActions: true,
                                      minTime: newDate,
                                      maxTime: newDate.add(Duration(days: 300)),
                                      onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    selectedDate = date;
                                    print('confirm $date');
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: Text(
                                  "Set Date",
                                  style:
                                      TextStyle(color: kNotifcationBlueColor),
                                )),
                            TextButton(
                                onPressed: () {
                                  var parsed =
                                      DateTime.parse(DateTime.now().toString());
                                  var newDate = new DateTime(
                                      parsed.year, parsed.month, parsed.day);
                                  DatePicker.showTimePicker(context,
                                      showTitleActions: true,
                                      onChanged: (time) {
                                    print('change $time');
                                  }, onConfirm: (time) {
                                    selectedTimeFrom = time;
                                    print('confirm $time');
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: Text(
                                  "Set Time from",
                                  style:
                                      TextStyle(color: kNotifcationBlueColor),
                                )),
                            TextButton(
                                onPressed: () {
                                  var parsed =
                                      DateTime.parse(DateTime.now().toString());
                                  var newDate = new DateTime(
                                      parsed.year, parsed.month, parsed.day);
                                  DatePicker.showTimePicker(context,
                                      showTitleActions: true,
                                      onChanged: (time) {
                                    print('change $time');
                                  }, onConfirm: (time) {
                                    selectedTimeTo = time;
                                    print('confirm $time');
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                child: Text(
                                  "Set Time to",
                                  style:
                                      TextStyle(color: kNotifcationBlueColor),
                                )),
                          ],
                        ),
                      Text(
                        "Order Items",
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      ).tr(),
                      ...response['orderDetails']
                          .map((order) => Card(
                                child: Container(
                                  height: 140,
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Image.network(
                                        "${Utilities.baseImgUrl}${order['proImg']}",
                                        fit: BoxFit.cover,
                                      )),
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(order['proName']),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('Price').tr(),
                                                    Text(": ${order['proQty']}")
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('Quantity').tr(),
                                                    Text(": ${order['proQty']}")
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                      SizedBox(
                        height: 15,
                      ),
                      if (nextStatus != null &&
                          response['orderStatus'] == 'Pending')
                        MainButton(
                          title: nextStatus,
                          onPressed: () async {
                            if (selectedDate == null) {
                              return Utilities.showSnackBar(
                                  context, "Please select a pickup Date".tr());
                            }
                            if (selectedTimeFrom == null) {
                              return Utilities.showSnackBar(context,
                                  "Please select a pickup from Time".tr());
                            }
                            if (selectedTimeFrom == null) {
                              return Utilities.showSnackBar(context,
                                  "Please select a pickup to Time".tr());
                            }

                            Utilities.showLoading();
                            final response = await Utilities.getPostRequestData(
                                url: "${Utilities.baseUrl}storeOrderTime.php",
                                form: {
                                  "orderId": widget.orderId,
                                  "pickupDate":
                                      "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                                  "pickupTimeFrom":
                                      "${selectedTimeFrom.hour}:${selectedTimeFrom.minute}",
                                  "pickupTimeTo":
                                      "${selectedTimeTo.hour}:${selectedTimeTo.minute}",
                                });
                            Logger().i(response);

                            await Provider.of<StoreOrdersProvider>(context,
                                    listen: false)
                                .updateOrderStatus(
                                    storeId: widget.storeId,
                                    orderId: widget.orderId,
                                    orderStatus: nextStatus);
                            Utilities.dismissLoading();
                            Utilities.showSnackBar(
                                context, "Status updated successfully".tr());
                            Navigator.of(context).pop();
                          },
                        )
                    ],
                  )),
                ],
              ),
            ),
    );
  }
}
