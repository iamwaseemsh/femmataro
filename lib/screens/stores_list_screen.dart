import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/models/address_model.dart';
import 'package:spain_project/models/payment_info_model.dart';
import 'package:spain_project/networking/store.dart';
import 'package:spain_project/providers/bills_provider.dart';
import 'package:spain_project/providers/discount_providers.dart';
import 'package:spain_project/providers/store_product_provider.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/screens/choosing_plan_screen.dart';
import 'package:spain_project/screens/storemanager/home_screen.dart';
import 'package:spain_project/utils/utilities.dart';

import 'auth/add_new_store.dart';

class StoresListScreen extends StatefulWidget {
  @override
  _StoresListScreenState createState() => _StoresListScreenState();
}

class _StoresListScreenState extends State<StoresListScreen> {
  bool _loading = true;

  getStoresList() async {
    await Provider.of<StoreProvider>(context, listen: false).getAndSetStores();
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStoresList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
          "Stores".tr(),
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: AddNewStore()));
              },
              icon: Icon(
                Icons.add,
                color: kPrimaryColor,
                size: 30,
              ))
        ],
      ),
      body: Container(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<StoreProvider>(context, listen: false)
                        .getAndSetStores();
                  },
                  child: ListView(
                    children: [
                      ...Provider.of<StoreProvider>(context)
                          .storeList
                          .map((e) => Card(
                                child: ListTile(
                                  onTap: () async {
                                    Utilities.showLoading();
                                    Provider.of<StoreProvider>(context,
                                            listen: false)
                                        .setStore(e);
                                    final result =
                                        await StoreServices.isStorePaid(
                                            e.storeId, e.storeCatId);
                                    Logger().i(result);

                                    if (result['paymentStatus'] == true) {
                                      Provider.of<StoreProductProvider>(context,
                                              listen: false)
                                          .setPreProductsList(
                                              result['productsList']);
                                      Provider.of<BillsProvider>(context,
                                              listen: false)
                                          .setPreBills(result['subscriptions']);
                                      Provider.of<BillsProvider>(context,
                                              listen: false)
                                          .setPreHistoryList(
                                              result['salesRecord']);
                                      Provider.of<BillsProvider>(context,
                                              listen: false)
                                          .setPreStatList(
                                              result['monthlySales']);
                                      Provider.of<BillsProvider>(context,
                                              listen: false)
                                          .setTotalSale(
                                              result['totalOrderAmount']
                                                  .toStringAsFixed(2));
                                      Provider.of<DiscountProvider>(context,
                                              listen: false)
                                          .setPreDisocunt(
                                              result['DiscountList']);
                                      Provider.of<StoreProductProvider>(context,
                                              listen: false)
                                          .setPreProCats(result['proCatList']);
                                      Provider.of<StoreProvider>(context,
                                              listen: false)
                                          .setStoreAddress(AddressModel(
                                              address: result['address'],
                                              postalCode:
                                                  result['postalCode']));
                                      Provider.of<StoreProvider>(context,
                                              listen: false)
                                          .setStorePayment(PaymentInfoModel(
                                              tokenKey: result['userToken'],
                                              merchantKey: result['merchantId'],
                                              publicKey: result['publicKey'],
                                              secretKey: result['privateKey']));
                                      EasyLoading.dismiss();
                                      await Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .leftToRight,
                                              child: StoreManagerScreen()));
                                    } else {
                                      EasyLoading.dismiss();
                                      await Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType
                                                  .leftToRight,
                                              child: ChoosingPlanScreen(
                                                  storeId: e.storeId)));
                                    }
                                  },
                                  subtitle: Text(e.storeAddress),
                                  leading: Container(
                                      height: 40,
                                      width: 40,
                                      child: Image.asset(
                                        'assets/shop.png',
                                        fit: BoxFit.cover,
                                      )),
                                  title: Text(
                                    e.storeName,
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 20),
                                  ),
                                  trailing: CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.deepOrange,
                                    child: Text(
                                      e.pendingOrders.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ))
                          .toList()
                          .reversed
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class PopupOptionMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: Colors.black54,
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
              child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).pop();
                    print('helo');
                    // Navigator.push(
                    //     context,
                    //     PageTransition(
                    //         type: PageTransitionType.topToBottom,
                    //         child: AddNewStore()));
                  },
                  child: Text('Add Store'))),
          PopupMenuItem(
              child: GestureDetector(
                  onTap: () {
                    print('Setting tap');
                    Navigator.of(context).pop();
                  },
                  child: Text('Payment method'))),
        ];
      },
    );
  }
}
