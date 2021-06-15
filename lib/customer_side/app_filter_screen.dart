import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/providers/customer_providers.dart';

import '../utils/utilities.dart';
import '../widgets/main_button.dart';

class AppFilterScreen extends StatefulWidget {
  @override
  _AppFilterScreenState createState() => _AppFilterScreenState();
}

class _AppFilterScreenState extends State<AppFilterScreen> {
  bool applyFilterLoading = false;

  bool loading = true;
  bool discountedPrice = false;
  bool seeAll = true;
  List<String> selectedStoreCatList = [];
  List<String> selectedProductCatList = [];
  List<FilterOfferModel> _offers = [
    FilterOfferModel(id: "discounted", name: "Discount Products"),
    FilterOfferModel(id: "all", name: "See All")
  ];
  List<FilterStoreCatModel> _storeCatList = [];
  List<FilterProductCatModel> _productCatList = [];
  bool proLoading = false;
  getAndSetData() async {
    _productCatList = [];
    _storeCatList = [];
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}getAllCats.php", form: {});

    // for (var item in response['proCats']) {
    //   _productCatList.add(FilterProductCatModel(
    //       proCatId: item['proCatId'], proCatName: item['proCatName']));
    // }

    for (var item in response['storeCats']) {
      _storeCatList.add(
        FilterStoreCatModel(
            storeCatId: item['storeCatId'], storeCatName: item['storeCatName']),
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndSetData();
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Filters",
          style: TextStyle(color: Colors.black),
        ).tr(),
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
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Offers".tr(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2.5,
                              padding: EdgeInsets.only(right: 30),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: discountedPrice,
                                      onChanged: (value) {
                                        setState(() {
                                          if (discountedPrice == true) {
                                            discountedPrice = false;
                                            seeAll = true;
                                          } else {
                                            discountedPrice = true;
                                            seeAll = false;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Discounted Products'.tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 2.5,
                              padding: EdgeInsets.only(right: 30),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: seeAll,
                                      onChanged: (value) {
                                        setState(() {
                                          if (seeAll == true) {
                                            discountedPrice = true;
                                            seeAll = false;
                                          } else {
                                            discountedPrice = false;
                                            seeAll = true;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Sell All'.tr(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black54),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Store Categories",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ).tr(),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          children: [
                            ..._storeCatList
                                .map((e) => Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      padding: EdgeInsets.only(right: 30),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: Checkbox(
                                              value: e.ifChecked,
                                              onChanged: (value) async {
                                                setState(() {
                                                  _storeCatList =
                                                      _storeCatList.map((item) {
                                                    if (item.storeCatId ==
                                                        e.storeCatId) {
                                                      return FilterStoreCatModel(
                                                          storeCatId:
                                                              item.storeCatId,
                                                          storeCatName:
                                                              item.storeCatName,
                                                          ifChecked: true);
                                                    } else {
                                                      return FilterStoreCatModel(
                                                          storeCatId:
                                                              item.storeCatId,
                                                          storeCatName:
                                                              item.storeCatName,
                                                          ifChecked: false);
                                                    }
                                                  }).toList();
                                                  proLoading = true;
                                                });
                                                final response = await Utilities
                                                    .getPostRequestData(
                                                        url:
                                                            "${Utilities.baseUrl}returnStoresAsStoreCat.php",
                                                        form: {
                                                      'storeCatId': e.storeCatId
                                                    });
                                                Logger().i(response);
                                                _productCatList = [];
                                                for (var item
                                                    in response['proCats']) {
                                                  _productCatList.add(
                                                      FilterProductCatModel(
                                                          proCatId:
                                                              item['proCatId'],
                                                          proCatName: item[
                                                              'proCatName']));
                                                }
                                                setState(() {
                                                  proLoading = false;
                                                });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Text(
                                              e.storeCatName,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54),
                                            ),
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Product Categories".tr(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        proLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Wrap(
                                children: [
                                  ..._productCatList
                                      .map((e) => Container(
                                            // height: 50,
                                            padding: EdgeInsets.only(
                                                right: 30, bottom: 20),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: Checkbox(
                                                    value: e.ifChecked,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        e.ifChecked =
                                                            !e.ifChecked;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    e.proCatName,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black54,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ],
                              )
                      ],
                    ),
                  ),
                  applyFilterLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : MainButton(
                          title: "Apply Filters".tr(),
                          onPressed: () async {
                            selectedProductCatList = [];
                            selectedStoreCatList = [];

                            for (var item in _storeCatList) {
                              if (item.ifChecked == true) {
                                selectedStoreCatList.add("${item.storeCatId}");
                              }
                            }
                            for (var item in _productCatList) {
                              if (item.ifChecked == true) {
                                selectedProductCatList.add("${item.proCatId}");
                              }
                            }

                            // else if (selectedProductCatList.isEmpty) {
                            //   return Utilities.showSnackBar(context,
                            //       "Please select atleast 1 product category");
                            // }
                            // setState(() {
                            //   applyFilterLoading = true;
                            // });
                            EasyLoading.show(
                              status: 'loading..',
                            );
                            String filterId;
                            if (discountedPrice == true) {
                              filterId = 'discounted';
                            } else {
                              filterId = 'all';
                            }
                            Logger().i(filterId);
                            final response2 =
                                await Utilities.getPostRequestData(
                              url: "${Utilities.baseUrl}filteredProducts.php",
                              form: {
                                "proCatsId": jsonEncode(selectedProductCatList),
                                "storeCatsId": jsonEncode(selectedStoreCatList),
                                'filterId': filterId
                              },
                            );

                            await Provider.of<CustomerOffersProvider>(context,
                                    listen: false)
                                .setCustomProducts(response2);
                            EasyLoading.dismiss();
                            Navigator.of(context).pop();
                          },
                        ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
    );
  }
}

class FilterStoreCatModel {
  final String storeCatId;
  final String storeCatName;
  bool ifChecked;
  FilterStoreCatModel(
      {this.ifChecked = false, this.storeCatId, this.storeCatName});
}

class FilterProductCatModel {
  final String proCatId;
  final String proCatName;
  bool ifChecked;
  FilterProductCatModel(
      {this.ifChecked = false, this.proCatId, this.proCatName});
}

class FilterOfferModel {
  final String id;
  final String name;
  bool ifChecked;
  FilterOfferModel({this.ifChecked = false, this.id, this.name});
}
