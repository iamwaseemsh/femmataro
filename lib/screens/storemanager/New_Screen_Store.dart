import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/models/store_product_model.dart';
import 'package:spain_project/providers/store_product_provider.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/screens/products_files/create_new_product.dart';
import 'package:spain_project/screens/products_files/update_product_screen.dart';
import 'package:spain_project/utils/utilities.dart';

class NewScreenStore extends StatefulWidget {
  @override
  _NewScreenStoreState createState() => _NewScreenStoreState();
}

class _NewScreenStoreState extends State<NewScreenStore> {
  bool _loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndSetProducts();
  }

  getAndSetProducts() async {
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
    return SafeArea(
        child: Scaffold(
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
                Logger().i("store has all keys $response");
                if (response['message'] == false) {
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
    ));
  }
}

class Widget1 extends StatelessWidget {
  StoreProductModel product;
  Widget1(this.product);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("hello update start");
        Navigator.push(
            context,
            PageTransition(
                alignment: Alignment.center,
                type: PageTransitionType.size,
                child: UpdateProductScreen(product.proId)));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Card(
          child: Container(
            height: 300,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
                // color: Colors.red,
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        child: Image.network(
                          '${Utilities.baseImgUrl}${product.proImg}',
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        product.proName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("€${product.proPrice}"),
                      Text("${product.discountPercent}%"),
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
