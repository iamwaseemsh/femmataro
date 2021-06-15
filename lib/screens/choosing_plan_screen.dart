import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/screens/payment_successfull_screen.dart';
import 'package:spain_project/screens/storemanager/home_screen.dart';
import 'package:spain_project/utils/utilities.dart';

class ChoosingPlanScreen extends StatefulWidget {
  final String storeId;
  ChoosingPlanScreen({this.storeId});

  @override
  _ChoosingPlanScreenState createState() => _ChoosingPlanScreenState();
}

class _ChoosingPlanScreenState extends State<ChoosingPlanScreen> {
  Future<bool> requestPayment({String amount, String plan}) async {
    Logger().i('here');
    var request = BraintreeDropInRequest(
        tokenizationKey: 'sandbox_5rmhq7bp_8kzh34xtn99yj2t9',
        collectDeviceData: true,
        paypalRequest: BraintreePayPalRequest(
            amount: amount, displayName: "Femmetaro", currencyCode: 'EUR'),
        cardEnabled: true);
    BraintreeDropInResult result = await BraintreeDropIn.start(request);
    if (result != null) {
      Utilities.showLoading();
      print(result.paymentMethodNonce.description);
      print(result.paymentMethodNonce.nonce);
      DateTime currentDateTime = DateTime.now();
      DateTime exp;

      if (plan == 'monthly') {
        exp = currentDateTime.add(Duration(days: 30));
      } else {
        exp = currentDateTime.add(Duration(days: 365));
      }
      final now = DateTime.now().toString();
      final response = await Utilities.getPostRequestData(
          url: '${Utilities.baseUrl}brain/transection.php',
          form: {
            "storeId": widget.storeId.toString(),
            "paymentDate": now,
            "nonce": result.paymentMethodNonce.nonce.toString(),
            "paymentAmount": amount.toString(),
            "paymentPlan": plan,
            "expiryDate": exp.toString()
          });

      Logger().i(response);

      EasyLoading.dismiss();
      if (response['message'] == true) {
        return true;
      } else {
        return false;
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
          child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
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
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                    child: Text(
                  "Choose your Plan".tr(),
                  textAlign: TextAlign.center,
                  style: kHeadingTextStype,
                )),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                    child: AutoSizeText(
                  "Select a single annual payment and save 60€ or pay monthly"
                      .tr(),
                  textAlign: TextAlign.center,
                  style: kSubHeadingTextStyle,
                )),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  final result =
                      await requestPayment(amount: "120", plan: 'yearly');

                  if (result == true) {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: PaymentSuccessfullScreen(
                              title1: "Upload your offers".tr(),
                              title2: "See my profile".tr(),
                              heading: "Your payment has been accepted".tr(),
                              onPressed1: (ctx) {
                                Navigator.pushReplacement(
                                    ctx,
                                    PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        child: StoreManagerScreen()));
                              },
                              onPressed2: (ctx) {
                                Navigator.pushReplacement(
                                    ctx,
                                    PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        child: StoreManagerScreen()));
                              },
                              subItems: [
                                "Your subscription has been accepted and is now available to upload your offers!"
                                    .tr(),
                                "You received an e-mail with the invoice details of your payment"
                                    .tr()
                              ],
                            )));
                  } else {
                    Utilities.showSnackBar(
                        context, "Payment couldn't be done".tr());
                    Timer(Duration(seconds: 2), () {
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/buttons/btnback2.png'))),
                  child: Center(
                      child: AutoSizeText(
                    "Annual 10€/Month".tr(),
                    style: kHeadingTextStype.copyWith(
                        color: Colors.white, fontSize: 18),
                  )),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "- Or -".tr(),
                  style: kHeadingTextStype.copyWith(fontSize: 18),
                ),
              ),
              InkWell(
                onTap: () async {
                  final result2 =
                      await requestPayment(amount: '15', plan: 'monthly');

                  if (result2 == true) {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: PaymentSuccessfullScreen(
                              title1: "Upload your offers".tr(),
                              title2: "See my profile".tr(),
                              heading: "Your payment has been accepted".tr(),
                              onPressed1: (ctx) {
                                Navigator.pushReplacement(
                                    ctx,
                                    PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        child: StoreManagerScreen()));
                              },
                              onPressed2: (ctx) {
                                Navigator.pushReplacement(
                                    ctx,
                                    PageTransition(
                                        type: PageTransitionType.leftToRight,
                                        child: StoreManagerScreen()));
                              },
                              subItems: [
                                "Your subscription has been accepted and is now available to upload your offers!"
                                    .tr(),
                                "You received an e-mail with the invoice details of your payment"
                                    .tr()
                              ],
                            )));
                  } else {
                    Utilities.showSnackBar(
                        context, "Payment couldn't be done".tr());
                    Timer(Duration(seconds: 2), () {
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/buttons/btnback1.png'))),
                  child: Center(
                      child: AutoSizeText(
                    "Monthly 15€/Month".tr(),
                    style: kHeadingTextStype.copyWith(fontSize: 18),
                  )),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
