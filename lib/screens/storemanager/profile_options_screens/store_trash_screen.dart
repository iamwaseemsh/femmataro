import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/models/trash_product_model.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/providers/trash_provider.dart';
import 'package:spain_project/utils/utilities.dart';

class StoreTrashScreen extends StatefulWidget {
  @override
  _StoreTrashScreenState createState() => _StoreTrashScreenState();
}

class _StoreTrashScreenState extends State<StoreTrashScreen> {
  bool _loading = true;
  getAndSet() async {
    String storeId =
        Provider.of<StoreProvider>(context, listen: false).store.storeId;
    await Provider.of<TrashProvider>(context, listen: false)
        .getAndSetTrashProductList(storeId);
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndSet();
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
          "Trash Bin".tr(),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: [
                  ...Provider.of<TrashProvider>(context)
                      .trashProductsList
                      .map((e) => TrashProductWidget(e))
                      .toList()
                ],
              ),
            ),
    );
  }
}

class TrashProductWidget extends StatelessWidget {
  TrashProductModel product;
  TrashProductWidget(this.product);
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(10),
          height: 140,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Text(
                    "Name".tr(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  )),
                  Expanded(child: Text(product.proName))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Text(
                    "Price".tr(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  )),
                  Expanded(child: Text(product.proPrice))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: Text(
                    "Category".tr(),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  )),
                  Expanded(child: Text(product.proCatName))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      String storeId =
                          Provider.of<StoreProvider>(context, listen: false)
                              .store
                              .storeId;
                      await Provider.of<TrashProvider>(context, listen: false)
                          .restoreTrashProduct(product.proId, storeId);
                      Utilities.showSnackBar(context, "Product restored".tr());
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: kPrimaryColor),
                      child: Text(
                        "Restore".tr(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      if (await confirm(
                        context,
                        title: Text("Confirm".tr()),
                        content: Text("Are you sure".tr()),
                        textOK: Text('Yes'.tr()),
                        textCancel: Text('No'.tr()),
                      )) {
                        String storeId =
                            Provider.of<StoreProvider>(context, listen: false)
                                .store
                                .storeId;
                        await Provider.of<TrashProvider>(context, listen: false)
                            .deleteTrashProduct(product.proId, storeId);
                        Utilities.showSnackBar(context, "Product Deleted".tr());
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(width: 1, color: kPrimaryColor)),
                      child: Text(
                        "Delete".tr(),
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
