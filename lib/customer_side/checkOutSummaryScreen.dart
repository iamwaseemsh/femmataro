import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/customer_side/payment_accepted_screen.dart';
import 'package:spain_project/providers/cart_provider.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/main_button.dart';

class CheckOutSummaryScreen extends StatefulWidget {
  final String amount;
  final List<dynamic> products;
  final String storeId;
  final String userEmail;
  final String tokenKey;
  final String userAddress;
  final String postalCode;
  final List<dynamic> proIds;
  CheckOutSummaryScreen(
      {this.storeId,
      this.products,
      this.amount,
      this.tokenKey,
      this.userEmail,
      this.proIds,
      this.postalCode,
      this.userAddress});
  @override
  _CheckOutSummaryScreenState createState() => _CheckOutSummaryScreenState();
}

class _CheckOutSummaryScreenState extends State<CheckOutSummaryScreen> {
  bool isSummary = true;
  bool loading = true;
  // LocationData currentLocation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndSet();
  }

  getAndSet() async {
    // await getUserLocation();
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Utilities.dismissLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          isSummary ? "Summary".tr() : "",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: .8,
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isSummary
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      // Text("Address").tr(),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(vertical: 10),
                      //   child: Text(
                      //     widget.userAddress,
                      //     style: TextStyle(fontSize: 18, color: Colors.black54),
                      //   ),
                      // ),
                      // Divider(
                      //   height: 1,
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Text("Postal Code").tr(),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(vertical: 10),
                      //   child: Text(
                      //     widget.postalCode,
                      //     style: TextStyle(fontSize: 18, color: Colors.black54),
                      //   ),
                      // ),
                      // Divider(
                      //   height: 1,
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 160,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black12.withOpacity(.1),
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                "Summary".tr(),
                                style: TextStyle(
                                    fontSize: 40,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total amount".tr(),
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "${widget.amount}€",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      MainButton(
                        onPressed: () async {
                          setState(() {
                            isSummary = false;
                          });
                          return;
                        },
                        title: "Confirm Order".tr(),
                      )
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 70,
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.cover,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          "Choose your payment method",
                          style: kHeadingTextStype,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "Select one of the options",
                          style: kSubHeadingTextStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      MainButton(
                        title: 'Credit Card',
                        onPressed: () {
                          getPayment('card');
                        },
                        color: Color(0xffEFEEEE),
                        isBlackText: true,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MainButton(
                        title: 'PayPal',
                        onPressed: () {
                          getPayment('paypal');
                        },
                        color: Color(0xff1274BD),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MainButton(
                        title: 'Apple Pay',
                        onPressed: () {
                          getPayment('apple');
                        },
                        color: Color(0xff000000),
                      ),
                    ],
                  ),
                ),
    );
  }

  getPayment(String type) async {
    Utilities.showLoading();

    final items = jsonEncode(widget.products);

    var request = type == 'paypal'
        ? BraintreeDropInRequest(
            tokenizationKey: widget.tokenKey,
            collectDeviceData: true,
            paypalRequest: BraintreePayPalRequest(
                amount: widget.amount,
                displayName: "Femetaro",
                currencyCode: 'EUR'),
            cardEnabled: false)
        : BraintreeDropInRequest(
            tokenizationKey: widget.tokenKey,
            collectDeviceData: true,
            cardEnabled: true,
          );

    BraintreeDropInResult result = await BraintreeDropIn.start(request);
    if (result != null) {
      print(result.paymentMethodNonce.description);
      print(result.paymentMethodNonce.nonce);
      final data = {
        "products": items,
        "userEmail": widget.userEmail,
        "nonce": result.paymentMethodNonce.nonce,
        "storeId": widget.storeId.toString(),
        // "latitude": currentLocation.latitude.toString(),
        // "langitude": currentLocation.longitude.toString(),
        "address": widget.userAddress,
        "postalCode": widget.postalCode,
        "totalAmount": widget.amount.toString()
      };

      final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}brain/order.php",
        form: data,
      );

      for (var item in widget.proIds) {
        Logger().w(item);
        await Provider.of<CartProvider>(context, listen: false)
            .removeCartItem(item);
      }
      EasyLoading.dismiss();
      Utilities.showSnackBar(
          context, "Your order has been placed successfully".tr());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => PaymentAcceptedScreen()));
      // Timer(Duration(milliseconds: 300), () {
      //   Navigator.of(context).pop();
      // });
    } else {
      EasyLoading.dismiss();
      Utilities.showSnackBar(context, "Payment Unsuccessful. Try again.".tr());
    }
  }
}
