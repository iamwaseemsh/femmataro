import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/customer_side/checkOutSummaryScreen.dart';
import 'package:spain_project/utils/shared_pref_services.dart';

import '../../constants/constants.dart';
import '../../providers/cart_provider.dart';
import '../../utils/utilities.dart';
import '../../widgets/main_button.dart';

class CustomerCartScreen extends StatefulWidget {
  @override
  _CustomerCartScreenState createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  List<StoreModel> storesList = [];
  String storeId;
  bool loading = true;

  setStoreList() {
    storesList = [];
    for (var item
        in Provider.of<CartProvider>(context, listen: false).cartItemsList) {
      if ((storesList.singleWhere((it) => it.storeId == item.storeId,
              orElse: () => null)) !=
          null) {
      } else {
        storeId = item.storeId;
        storesList
            .add(StoreModel(storeId: item.storeId, storeName: item.storeName));
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setStoreList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Utilities.dismissLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "CART".tr(),
              style: TextStyle(color: Colors.black87),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: .8,
          ),
          body: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // TextButton(
                      //     onPressed: () async {
                      //       final response =
                      //           await SharedPrefServices.getListValue(
                      //               name: 'cartItemsList');
                      //       Logger().i(response);
                      //     },
                      //     child: Text(""
                      //         "get list")),
                      // TextButton(
                      //     onPressed: () async {
                      //       List<String> list = [];
                      //
                      //       await SharedPrefServices.setListValue(
                      //           name: 'cartItemsList', values: list);
                      //       await SharedPrefServices.setListValue(
                      //           name: 'wishlist', values: list);
                      //     },
                      //     child: Text(""
                      //         "delete list")),
                      // TextButton(
                      //     onPressed: () async {
                      //       Provider.of<CartProvider>(context, listen: false)
                      //           .cartItemsList = [];
                      //     },
                      //     child: Text(""
                      //         "set cart list")),
                      if (Provider.of<CartProvider>(context)
                              .cartItemsList
                              .length >
                          0)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            child: Card(
                              shape: Border(
                                  right: BorderSide(
                                      color: kPrimaryColor, width: 7)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                ),
                                height: 70,
                                // color: Colors.red,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Center(
                                          child: Text(
                                            "Change store".tr(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                      child: DropdownButton<String>(
                                        iconEnabledColor:
                                            Colors.grey.withOpacity(.6),
                                        isExpanded: true,
                                        itemHeight: 50,
                                        iconSize: 30,
                                        hint: Text("Choose a store").tr(),
                                        items: storesList
                                            .map((e) => DropdownMenuItem(
                                                  child: Text(e.storeName),
                                                  value: e.storeId,
                                                ))
                                            .toList(),
                                        value: storeId,
                                        onChanged: (String value) {
                                          setState(() {
                                            storeId = value;
                                          });
                                        },
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                          child: ListView(
                        children: [
                          ...Provider.of<CartProvider>(context)
                              .cartItemsList
                              .where((element) => element.storeId == storeId)
                              .toList()
                              .map(
                                (e) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        bottom: 20,
                                        left: 10,
                                      ),
                                      // color: Colors.orange,
                                      height: 150,
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            height: 100,
                                            width: 100,
                                            child: CachedNetworkImage(
                                              imageUrl: '${e.proImg}',
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AutoSizeText(
                                                    e.proName,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        Provider.of<CartProvider>(
                                                                context,
                                                                listen: false)
                                                            .removeCartItem(
                                                                e.proId);
                                                        setStoreList();
                                                      })
                                                ],
                                              ),
                                              AutoSizeText(
                                                e.storeName,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Expanded(child: Container()),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            if (e.qty > 1) {
                                                              Provider.of<CartProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .decreaseQty(
                                                                      proId: e
                                                                          .proId);
                                                            }
                                                          },
                                                          icon: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 14),
                                                            child: Icon(
                                                              Icons.minimize,
                                                              color: e.qty == 1
                                                                  ? Colors
                                                                      .black54
                                                                  : kPrimaryColor,
                                                            ),
                                                          )),
                                                      Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .black12,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                        ),
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          child: Center(
                                                              child:
                                                                  AutoSizeText(
                                                            "${e.qty}",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 22),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )),
                                                        ),
                                                      ),
                                                      IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed: () {
                                                            Provider.of<CartProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .increateQty(
                                                                    proId:
                                                                        e.proId,
                                                                    qty: 1);
                                                          },
                                                          icon: Icon(
                                                            Icons.add,
                                                            color:
                                                                kPrimaryColor,
                                                          )),
                                                    ],
                                                  ),
                                                  AutoSizeText(
                                                    "${e.proPrice}€  ",
                                                    minFontSize: 20,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 10,
                                    )
                                  ],
                                ),
                              )
                              .toList()
                        ],
                      )),
                      if (Provider.of<CartProvider>(context)
                              .cartItemsList
                              .length >
                          0)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total".tr(),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                              Text(
                                "${Provider.of<CartProvider>(context).cartItemsList.where((element) => element.storeId == storeId).toList().map((e) => double.parse(e.proPrice) * e.qty).reduce((v, e) => v + e).toStringAsFixed(2)}€",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87),
                              )
                            ],
                          ),
                        ),
                      if (Provider.of<CartProvider>(context)
                              .cartItemsList
                              .length >
                          0)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 2),
                          child: MainButton(
                            title: "Checkout".tr(),
                            onPressed: () async {
                              EasyLoading.show(
                                status: 'loading..',
                              );
                              List temp = [];
                              List proIdz = [];
                              for (var item in Provider.of<CartProvider>(
                                      context,
                                      listen: false)
                                  .cartItemsList
                                  .where(
                                      (element) => element.storeId == storeId)
                                  .toList()) {
                                proIdz.add(item.proId);
                                temp.add(item.toMap());
                              }
                              var amount = Provider.of<CartProvider>(context,
                                      listen: false)
                                  .cartItemsList
                                  .where(
                                      (element) => element.storeId == storeId)
                                  .toList()
                                  .map((e) => double.parse(e.proPrice) * e.qty)
                                  .reduce((v, e) => v + e);
                              final currentUser =
                                  await SharedPrefServices.getCurrentUser();

                              final response = await Utilities.getPostRequestData(
                                  url:
                                      "${Utilities.baseUrl}getStoreTokenizationKey.php",
                                  form: {
                                    "storeId": storeId,
                                    "userEmail": currentUser['email']
                                  });
                              EasyLoading.dismiss();

                              await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (ctx) => CheckOutSummaryScreen(
                                          tokenKey: response['token'],
                                          amount: amount.toStringAsFixed(2),
                                          products: temp,
                                          storeId: storeId,
                                          userEmail: currentUser['email'],
                                          proIds: proIdz,
                                          userAddress:
                                              response['userAddress'] ?? '',
                                          postalCode:
                                              response['postalCode'] ?? '')));
                              setStoreList();
                            },
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class StoreModel {
  final String storeId;
  final String storeName;
  StoreModel({this.storeName, this.storeId});
}
