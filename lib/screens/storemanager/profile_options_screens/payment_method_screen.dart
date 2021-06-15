import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/models/payment_info_model.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/form_field_widget.dart';
import 'package:spain_project/widgets/main_button.dart';

class PaymentMethodStoreScreen extends StatefulWidget {
  @override
  _PaymentMethodStoreScreenState createState() =>
      _PaymentMethodStoreScreenState();
}

class _PaymentMethodStoreScreenState extends State<PaymentMethodStoreScreen> {
  bool loading = false;
  bool updateLoading = false;
  TextEditingController _token = TextEditingController();
  TextEditingController _merchant = TextEditingController();
  TextEditingController _public = TextEditingController();
  TextEditingController _secret = TextEditingController();
  getAndSet() async {
    setState(() {
      _token.text = Provider.of<StoreProvider>(context, listen: false)
          .storePaymentInfo
          .tokenKey;
      _merchant.text = Provider.of<StoreProvider>(context, listen: false)
          .storePaymentInfo
          .merchantKey;
      _public.text = Provider.of<StoreProvider>(context, listen: false)
          .storePaymentInfo
          .publicKey;
      _secret.text = Provider.of<StoreProvider>(context, listen: false)
          .storePaymentInfo
          .secretKey;
    });
    return;
    setState(() {
      loading = true;
    });
    String storeId =
        Provider.of<StoreProvider>(context, listen: false).store.storeId;
    final response = await Utilities.getPostRequestData(
        form: {"storeId": storeId},
        url: "${Utilities.baseUrl}checkPaymentInfo.php");
    print(response);
    if (response['message'] == true) {
      setState(() {
        _token.text = response['userToken'];
        _merchant.text = response['merchantId'];
        _public.text = response['publicKey'];
        _secret.text = response['privateKey'];
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndSet();
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
          "Payment method",
          style: TextStyle(color: Colors.black),
        ).tr(),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Image.asset(
                          'assets/braintree.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Set your payment information",
                        style:
                            kHeadingTextStype.copyWith(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ).tr(),
                      SizedBox(
                        height: 30,
                      ),
                      FormFieldWidget(
                        label: 'Tokenization key',
                        hint: "X X X X X X X X X",
                        controller: _token,
                      ),
                      FormFieldWidget(
                        label: 'Merchant Id',
                        hint: "X X X X X X X X X",
                        controller: _merchant,
                      ),
                      FormFieldWidget(
                        label: 'Public key',
                        hint: "X X X X X X X X X",
                        controller: _public,
                      ),
                      FormFieldWidget(
                        label: 'Secret key',
                        hint: "X X X X X X X X X",
                        controller: _secret,
                      ),
                      updateLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : MainButton(
                              title: "Update".tr(),
                              onPressed: () async {
                                if (_token.text.isEmpty) {
                                  return Utilities.showSnackBar(context,
                                      'Tokenization key must not be empty');
                                } else if (_merchant.text.isEmpty) {
                                  return Utilities.showSnackBar(
                                      context, 'Merchant Id must not be empty');
                                }
                                if (_public.text.isEmpty) {
                                  return Utilities.showSnackBar(
                                      context, 'Public key must not be empty');
                                }
                                if (_secret.text.isEmpty) {
                                  return Utilities.showSnackBar(
                                      context, 'Secret key must not be empty');
                                }

                                Utilities.showLoading();
                                String storeId = Provider.of<StoreProvider>(
                                        context,
                                        listen: false)
                                    .store
                                    .storeId;
                                final response = await Utilities.getPostRequestData(
                                    url:
                                        "${Utilities.baseUrl}addPaymentInfo.php",
                                    form: {
                                      "storeId": storeId,
                                      "userTokenKey": _token.text.trim(),
                                      "merchantKey": _merchant.text.trim(),
                                      "publicKey": _public.text.trim(),
                                      "privateKey": _secret.text.trim()
                                    });
                                Provider.of<StoreProvider>(context,
                                        listen: false)
                                    .setStorePayment(PaymentInfoModel(
                                        tokenKey: _token.text.trim(),
                                        merchantKey: _merchant.text.trim(),
                                        publicKey: _public.text.trim(),
                                        secretKey: _secret.text.trim()));
                                print(response);
                                Utilities.dismissLoading();
                                if (response['message'] == "true") {}
                              },
                            )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
