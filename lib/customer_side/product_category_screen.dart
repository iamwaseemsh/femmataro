import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/customer_side/productDetailsScreen.dart';
import 'package:spain_project/customer_side/product_search_filter_screen.dart';
import 'package:spain_project/models/customer/offers_list_models.dart';
import 'package:spain_project/models/search_bar_item_model.dart';
import 'package:spain_project/providers/customer_providers.dart';
import 'package:spain_project/utils/utilities.dart';

class ProductCategoryScreen extends StatefulWidget {
  String storeCatId;
  ProductCategoryScreen(this.storeCatId);
  @override
  _ProductCategoryScreenState createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<ProductCategoryScreen> {
  bool loading = true;
  Future<List<SearchBarItemModel>> suggestionsCallback(String query) async {
    print("query selected $query");
    List<SearchBarItemModel> items = [];
    final url = Uri.parse('${Utilities.baseUrl}offersList.php');
    final response = await Utilities.getPostRequestData(
        url: '${Utilities.baseUrl}searchProductsByStoreCat.php',
        form: {"keyword": query, "storeCatId": widget.storeCatId});

    Logger().i(response);
    for (var item in response['searchedProducts']) {
      items.add(SearchBarItemModel(
        proId: item['proId'].toString(),
        proImg: item['proImg'],
        proPrice: item['proPrice'].toString(),
        proName: item['proName'],
      ));
    }

    final lowerQuery = query.toLowerCase();
    return items
        .where((element) => (element.proName.toLowerCase()).contains(query))
        .toList();
  }

  setAndData() async {
    await Provider.of<CustomerOffersProvider>(context, listen: false)
        .setProductCategories(widget.storeCatId);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAndData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(.5),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "What are you looking for?",
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
                  TypeAheadField<SearchBarItemModel>(
                    debounceDuration: Duration(milliseconds: 500),
                    hideSuggestionsOnKeyboardHide: true,
                    hideOnEmpty: true,
                    textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                            hintText: "What offer do you want to find?".tr(),
                            hintStyle: TextStyle(
                                color: kGreyTextColor,
                                fontWeight: FontWeight.bold),

                            // prefix: Icon(Icons.search_outlined,color: kGreyTextColor,),
                            filled: true,
                            fillColor: kGreyTextColor.withOpacity(.1),
                            prefixIcon: Icon(
                              Icons.search_outlined,
                              color: kGreyTextColor,
                              size: 28,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: 13))),
                    itemBuilder: (context, SearchBarItemModel suggestoin) {
                      final product = suggestoin;
                      return ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            "${Utilities.baseImgUrl}${product.proImg}",
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          "${product.proName}",
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          "€${product.proPrice}",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    },
                    suggestionsCallback: suggestionsCallback,
                    onSuggestionSelected: (SearchBarItemModel suggestion) {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: ProductDetailsScreen(suggestion.proId)));
                    },
                  ),
                  // TextField(
                  //   style: TextStyle(color: kGreyTextColor),
                  //   onChanged: (value) {
                  //     Provider.of<CustomerOffersProvider>(context,
                  //             listen: false)
                  //         .searchProductCategory(value);
                  //   },
                  //   decoration: InputDecoration(
                  //     hintText: "Find product categories".tr(),
                  //     hintStyle: TextStyle(
                  //         color: kGreyTextColor, fontWeight: FontWeight.bold),
                  //
                  //     // prefix: Icon(Icons.search_outlined,color: kGreyTextColor,),
                  //     filled: true,
                  //     fillColor: kGreyTextColor.withOpacity(.1),
                  //     prefixIcon: Icon(
                  //       Icons.search_outlined,
                  //       color: kGreyTextColor,
                  //       size: 28,
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide.none,
                  //       borderRadius: BorderRadius.circular(15),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide.none,
                  //       borderRadius: BorderRadius.circular(15),
                  //     ),
                  //     contentPadding: EdgeInsets.symmetric(vertical: 13),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: Provider.of<CustomerOffersProvider>(
                        context,
                      ).productCategoryList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          childAspectRatio: .9,
                          mainAxisSpacing: 5),
                      itemBuilder: (BuildContext context, int index) {
                        ProductCategoryModel cat =
                            Provider.of<CustomerOffersProvider>(context)
                                .productCategoryList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: SearchProductScreen(cat.proCatId)));
                          },
                          child: Card(
                              elevation: 2,
                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${Utilities.baseImgUrl}${cat.proCatImgUrl}",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover)),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomRight,
                                            stops: [
                                              0.3,
                                              0.9
                                            ],
                                            colors: [
                                              Colors.black.withOpacity(.5),
                                              Colors.black.withOpacity(.2),
                                            ]),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Center(
                                      child: Text(
                                        cat.proCatName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  width: 220,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )),
                        );
                      },
                    ),
                  ),
                ],
              )),
    );
  }
}
