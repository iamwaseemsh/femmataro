import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/providers/store_orders_provider.dart';
import 'package:spain_project/utils/shared_pref_services.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:url_launcher/url_launcher.dart';

import 'give_rating_screen.dart';

class CustomerOrderDetailsScreen extends StatefulWidget {
  String orderId;

  CustomerOrderDetailsScreen({this.orderId});
  @override
  _CustomerOrderDetailsScreenState createState() =>
      _CustomerOrderDetailsScreenState();
}

class _CustomerOrderDetailsScreenState
    extends State<CustomerOrderDetailsScreen> {
  bool loading = true;
  var response;
  getOrderDetails() async {
    EasyLoading.show(status: 'Loading...');
    print("here");
    response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}userOrderDetails.php",
        form: {"orderId": widget.orderId});
    Logger().i(response);
    setState(() {});

    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderDetails();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
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
            "Order details".tr(),
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 0,
        ),
        body: response == null
            ? Center(
                child: Container(),
              )
            : Container(
                child: ListView(
                  children: [
                    Container(
                      height: 100,
                      color: response['orderStatus'] == 'Pending'
                          ? kNotifcationBlueColor
                          : kNotifcationGreenColor,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: response['storeLogo'],
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundImage: imageProvider,
                              backgroundColor: Colors.white,
                              radius: 30,
                            ),
                            placeholder: (context, url) => Container(
                              width: 220,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Container(
                            child: Text(
                              response['orderStatus'] == 'Pending'
                                  ? "Your order is being prepared, you will be able to pick it up soon"
                                  : response['orderStatus'] == 'Ready'
                                      ? "Your order is ready to pick up! :)"
                                      : "Your order has been completed",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CachedNetworkImage(
                      imageUrl: response['storeLogo'],
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        backgroundColor: Colors.white,
                        radius: 40,
                      ),
                      placeholder: (context, url) => Container(
                        width: 220,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        response['storeName'],
                        style:
                            kHeadingTextStype.copyWith(color: Colors.black54),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          bool isIOS =
                              Theme.of(context).platform == TargetPlatform.iOS;
                          Logger().i(isIOS);

                          var url = isIOS == true
                              ? 'https://maps.apple.com/?q=${response['storeLati']},${response['storeLongi']}'
                              : 'https://www.google.com/maps/search/?api=1&query=${response['storeLati']},${response['storeLongi']}';

                          // String googleUrl =
                          //     'https://www.google.com/maps/search/?api=1&query=${response['storeLati']},${response['storeLongi']}';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not open the map.';
                          }
                        },
                        child: Text(
                          "Direction Store",
                          style: TextStyle(
                              color: kNotifcationBlueColor.withOpacity(.5)),
                        )),
                    if (response['orderStatus'] == 'Completed')
                      Center(
                        child: Text(
                          "Tap on product in order to rate it.",
                          style:
                              TextStyle(color: Color(0xff717171), fontSize: 18),
                        ),
                      ),
                    ...response['orderDetails']
                        .map((order) => InkWell(
                              onTap: response['orderStatus'] == 'Completed'
                                  ? () async {
                                      if (order['isRated'] == true) {
                                        return Utilities.showSnackBar(context,
                                            'Product is already rated');
                                      }
                                      final user = await SharedPrefServices
                                          .getCurrentUser();
                                      final isRated =
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      GiveRatingScreen(
                                                          userEmail:
                                                              user['email'],
                                                          proId: order['proId'],
                                                          orderId: response[
                                                              'orderId'])));
                                      if (isRated == true) {
                                        setState(() {
                                          loading = true;
                                        });
                                        getOrderDetails();
                                      }
                                    }
                                  : null,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Text(
                                    "Q${order['proQty']} ${order['proName']}\(${order['proPrice']}\)",
                                    style: TextStyle(
                                      color:
                                          response['orderStatus'] == 'Pending'
                                              ? kNotifcationBlueColor
                                              : kNotifcationGreenColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 1,
                              color: response['orderStatus'] == 'Pending'
                                  ? Color(0xff717171)
                                  : kNotifcationGreenColor)),
                      height: 170,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: AutoSizeText(
                                        "Date",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Color(0xff717171),
                                            fontWeight: FontWeight.w600),
                                        minFontSize: 18,
                                      ),
                                    )),
                                    Expanded(
                                        child: AutoSizeText(
                                      "PICKUP TIME",
                                      maxLines: 1,
                                      minFontSize: 18,
                                      style: TextStyle(
                                          color: Color(0xff717171),
                                          fontWeight: FontWeight.w600),
                                    )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: AutoSizeText(
                                        response['pickupDate'] ?? "DD.MM.YYYY",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: response['orderStatus'] ==
                                                    'Pending'
                                                ? Color(0xff717171)
                                                : kNotifcationGreenColor,
                                            fontWeight: FontWeight.w600),
                                        minFontSize: 18,
                                      ),
                                    )),
                                    Expanded(
                                        child: AutoSizeText(
                                      "${response['pickupTimeFrom'] ?? "00:00"}-${response['pickupTimeTo'] ?? "00:00"}",
                                      minFontSize: 18,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: response['orderStatus'] ==
                                                  'Pending'
                                              ? Color(0xff717171)
                                              : kNotifcationGreenColor,
                                          fontWeight: FontWeight.w600),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              response['orderStatus'] == 'Completed'
                                  ? "Your order has been completed"
                                  : 'Your product is ready to pickup, from the date and our schedule time',
                              style: TextStyle(
                                  color: Color(0xff717171), fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (response['orderStatus'] != 'Completed')
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: AutoSizeText(
                          "When you are in the store and you have received the product, swipe to the right!",
                          style: TextStyle(color: Color(0xff979797)),
                        ),
                      ),
                    if (response['orderStatus'] == 'Ready')
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: kNotifcationGreenColor),
                              borderRadius: BorderRadius.circular(30)),
                          child: ConfirmationSlider(
                              foregroundColor: kNotifcationGreenColor,
                              height: 60,
                              text: "DELIVERED",
                              icon: Icons.double_arrow,
                              onConfirmation: () async {
                                Utilities.showLoading();
                                await Provider.of<StoreOrdersProvider>(context,
                                        listen: false)
                                    .updateOrderStatus(
                                        storeId: response['storeId'],
                                        orderId: widget.orderId,
                                        orderStatus: 'Completed');
                                Utilities.dismissLoading();
                                Utilities.showSnackBar(
                                    context, 'Order status updated');
                                Navigator.of(context).pop(true);

                                print("confirm");
                              },
                              backgroundShape: BorderRadius.circular(30)),
                        ),
                      ),
                    if (response['orderStatus'] == 'Pending')
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 2),
                                borderRadius: BorderRadius.circular(40)),
                            height: 60,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 3,
                                ),
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey,
                                  child: Icon(
                                    Icons.double_arrow,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                    child: Center(
                                        child: Text(
                                  "DELIVERED",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Color(0xff979696),
                                      fontWeight: FontWeight.w600),
                                )))
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ));
  }
}
//     : Container(
// padding: EdgeInsets.symmetric(horizontal: 20),
// child: Column(
// children: [
// Expanded(
// child: ListView(
// children: [
// Text(
// "Order Details".tr(),
// style: TextStyle(
// fontSize: 25,
// ),
// ),
// SizedBox(
// height: 10,
// ),
// Card(
// child: Container(
// padding: EdgeInsets.all(10),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// mainAxisSize: MainAxisSize.min,
// children: [
// Row(
// children: [
// Text('Order ID').tr(),
// Text(": ${response['orderId']}")
// ],
// ),
// Row(
// children: [
// Text('Order Amount').tr(),
// Text(": ${response['orderAmount']}")
// ],
// ),
// Row(
// children: [
// Text('Postal Code').tr(),
// Text(": ${response['postalCode']}")
// ],
// ),
// Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text('Address').tr(),
// Expanded(
// child: Text(": ${response['address']}"),
// )
// ],
// ),
// Row(
// children: [
// Text('Order Date').tr(),
// Text(": ${response['orderDate']}")
// ],
// ),
// Row(
// children: [
// Text('Order Time').tr(),
// Text(": ${response['orderTime']}")
// ],
// ),
// Row(
// children: [
// Text('Order Status').tr(),
// Text(": ${response['orderStatus']}")
// ],
// ),
// ],
// ),
// ),
// ),
// SizedBox(
// height: 10,
// ),
// Text(
// "Order Items".tr(),
// style: TextStyle(
// fontSize: 25,
// ),
// ),
// ...response['orderDetails']
// .map((order) => Card(
// child: Container(
// height: 140,
// padding: EdgeInsets.all(10),
// child: Row(
// children: [
// Expanded(
// child: Image.network(
// "${Utilities.baseImgUrl}${order['proImg']}",
// fit: BoxFit.cover,
// )),
// Expanded(
// flex: 2,
// child: Container(
// child: Column(
// mainAxisAlignment:
// MainAxisAlignment.center,
// children: [
// Text(order['proName']),
// Row(
// mainAxisAlignment:
// MainAxisAlignment.center,
// children: [
// Text('Price').tr(),
// Text(": ${order['proQty']}")
// ],
// ),
// Row(
// mainAxisAlignment:
// MainAxisAlignment.center,
// children: [
// Text('Quantity').tr(),
// Text(": ${order['proQty']}")
// ],
// ),
// SizedBox(
// height: 5,
// ),
// if (response['orderStatus'] ==
// 'Completed' &&
// order['isRated'] == false)
// InkWell(
// onTap: () async {
// final user =
//     await SharedPrefServices
//     .getCurrentUser();
// final isRated = await Navigator
//     .of(context)
// .push(MaterialPageRoute(
// builder: (ctx) => GiveRatingScreen(
// userEmail: user[
// 'email'],
// proId: order[
// 'proId'],
// orderId:
// response[
// 'orderId'])));
// if (isRated == true) {
// setState(() {
// loading = true;
// });
// getOrderDetails();
// }
// },
// child: Text(
// "Give rating".tr(),
// style: TextStyle(
// color: Colors
//     .lightBlueAccent),
// ))
// ],
// ),
// ))
// ],
// ),
// ),
// ))
// .toList(),
// SizedBox(
// height: 15,
// ),
// ],
// )),
// ],
// ),
// ),
