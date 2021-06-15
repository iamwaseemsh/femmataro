import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/models/store_product_model.dart';
import 'package:spain_project/providers/store_product_provider.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/screens/products_files/create_new_product.dart';
import 'package:spain_project/screens/storemanager/New_Screen_Store.dart';
import 'package:spain_project/utils/utilities.dart';

class ProductsScreenStore extends StatefulWidget {
  @override
  _ProductsScreenStoreState createState() => _ProductsScreenStoreState();
}

class _ProductsScreenStoreState extends State<ProductsScreenStore> {
  bool _loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getAndSetProducts() async {
    setState(() {
      _loading = true;
    });

    String storeId =
        Provider.of<StoreProvider>(context, listen: false).store.storeId;
    await Provider.of<StoreProductProvider>(context, listen: false)
        .getAndSetProductList(storeId);

    setState(() {
      _loading = false;
    });
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
          "My Products",
          style: TextStyle(color: Colors.black87),
        ).tr(),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                final storeId =
                    Provider.of<StoreProvider>(context, listen: false)
                        .store
                        .storeId;
                final response = await Utilities.getPostRequestData(
                    url: "${Utilities.baseUrl}checkCredentials.php",
                    form: {"storeId": storeId});
                if (response['message'] == false) {
                  return EasyLoading.showError(
                      'Please complete your payment information in order to add product'
                          .tr(),
                      dismissOnTap: true,
                      duration: Duration(seconds: 5));

                  return Utilities.showSnackBar(
                      context, 'Please complete your payment credential');
                }

                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: CreateNewProductScreen()));
              },
              icon: Icon(
                Icons.add,
                color: kPrimaryColor,
                size: 30,
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<StoreProductProvider>(context, listen: false)
              .getAndSetProductList(
                  Provider.of<StoreProvider>(context, listen: false)
                      .store
                      .storeId);
          setState(() {});
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: Provider.of<StoreProductProvider>(context)
                        .storeProductList
                        .length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 5),
                    itemBuilder: (BuildContext context, int index) {
                      List<StoreProductModel> items =
                          Provider.of<StoreProductProvider>(context)
                              .storeProductList;
                      return Widget1(items[index]);
                    },
                  )),
      ),
    );
  }
}
