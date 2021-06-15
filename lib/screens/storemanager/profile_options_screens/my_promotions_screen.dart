import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/providers/discount_providers.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/screens/storemanager/discount_screens/add_discount_screen.dart';
import 'package:spain_project/screens/storemanager/discount_screens/update_disount_screen.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/main_button.dart';

class MyPromotionsScreen extends StatefulWidget {
  @override
  _MyPromotionsScreenState createState() => _MyPromotionsScreenState();
}

class _MyPromotionsScreenState extends State<MyPromotionsScreen> {
  bool loading = false;
  setData() async {
    Utilities.showLoading();
    await Provider.of<DiscountProvider>(context, listen: false)
        .getAndSetDiscount(
            Provider.of<StoreProvider>(context, listen: false).store.storeId);
    Utilities.dismissLoading();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
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
          "My promotions",
          style: TextStyle(color: Colors.black),
        ).tr(),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(20),
              child: RefreshIndicator(
                onRefresh: () async {
                  await setData();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          ...Provider.of<DiscountProvider>(context)
                              .discountList
                              .map(
                                (e) {
                                  return Visibility(
                                    visible:
                                        e.discountCode != 'None' ? true : false,
                                    child: Card(
                                      child: ListTile(
                                          onTap: () {
                                            if (e.discountCode != 'None')
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      type: PageTransitionType
                                                          .bottomToTop,
                                                      child:
                                                          UpdateDiscountScreen(
                                                        discountCode:
                                                            e.discountCode,
                                                        discountId:
                                                            e.discountId,
                                                        discountPercent:
                                                            e.discountPercent,
                                                        expiryDate:
                                                            e.discountExpiry,
                                                      )));
                                          },
                                          title: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Discount Code").tr(),
                                              Text(": ${e.discountCode}"),
                                            ],
                                          ),
                                          trailing: Text(
                                            "${e.discountPercent}%",
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Expiry").tr(),
                                              Text(": ${e.discountExpiry}"),
                                            ],
                                          )),
                                    ),
                                  );
                                },
                              )
                              .toList()
                              .reversed,
                        ],
                      ),
                    ),
                    MainButton(
                      title: "Add a Discount".tr(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: AddDiscountScreen()));
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
