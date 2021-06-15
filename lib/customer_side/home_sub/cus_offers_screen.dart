import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/models/search_bar_item_model.dart';
import 'package:spain_project/providers/customer_providers.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/offer_widget.dart';

import '../app_filter_screen.dart';
import '../productDetailsScreen.dart';

class CustomerOffersScreen extends StatefulWidget {
  @override
  _CustomerOffersScreenState createState() => _CustomerOffersScreenState();
}

class _CustomerOffersScreenState extends State<CustomerOffersScreen> {
  bool _loading = false;
  bool _setAllLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<SearchBarItemModel>> suggestionsCallback(String query) async {
    print("query selected $query");
    List<SearchBarItemModel> items = [];
    final response = await Utilities.getPostRequestData(
        url: '${Utilities.baseUrl}searchProducts.php',
        form: {"keyword": query});
    Logger().i(response);
    Provider.of<CustomerOffersProvider>(context, listen: false)
        .setHomeSearchItems(response['searchedProducts']);
    // for (var item in response['searchedProducts']) {
    //   items.add(SearchBarItemModel(
    //     proId: item['proId'].toString(),
    //     proImg: item['proImg'],
    //     proPrice: item['proPrice'].toString(),
    //     proName: item['proName'],
    //   ));
    // }
    //

    // final lowerQuery = query.toLowerCase();
    //
    // return items
    //     .where((element) => (element.proName.toLowerCase()).contains(query))
    //     .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
            child: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView(
                    children: [
                      Center(
                        child: Container(
                            width: 80,
                            height: 50,
                            child: Image.asset(
                              'assets/logo.png',
                              color: kPrimaryColor,
                              fit: BoxFit.contain,
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.place_rounded,
                            color: kGreyTextColor,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Mataró, Barcelona",
                            style: TextStyle(
                                color: kGreyTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      TypeAheadField<SearchBarItemModel>(
                        debounceDuration: Duration(milliseconds: 500),
                        hideSuggestionsOnKeyboardHide: true,
                        hideOnEmpty: true,
                        textFieldConfiguration: TextFieldConfiguration(
                            decoration: InputDecoration(
                                hintText:
                                    "What offer do you want to find?".tr(),
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
                                  child:
                                      ProductDetailsScreen(suggestion.proId)));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (true)
                        Container(
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Carousel(
                              borderRadius: true,
                              dotSize: 4,
                              dotBgColor: Colors.transparent,
                              dotColor: kGreyTextColor,
                              dotPosition: DotPosition.bottomCenter,
                              radius: Radius.circular(10),
                              dotSpacing: 8,
                              dotIncreasedColor: kPrimaryColor,
                              overlayShadow: false,
                              images: [
                                ...Provider.of<CustomerOffersProvider>(context)
                                    .storeBanners
                                    .map((e) => Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${Utilities.baseImgUrl}$e",
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ))
                                    .toList()
                              ],
                            ),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Offers".tr(),
                            style: TextStyle(
                                color: kGreyTextColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.zero,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .leftToRight,
                                                child: AppFilterScreen()));
                                      },
                                      icon: Container(
                                          width: 20,
                                          height: 20,
                                          child: Image.asset(
                                            'assets/filter.png',
                                            fit: BoxFit.cover,
                                          )))),
                              TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      _setAllLoading = true;
                                    });
                                    await Provider.of<CustomerOffersProvider>(
                                            context,
                                            listen: false)
                                        .setAllProducts();
                                    setState(() {
                                      _setAllLoading = false;
                                    });
                                  },
                                  child: Text("See all").tr())
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 100,
                        child: ListView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          children: [
                            ...Provider.of<CustomerOffersProvider>(context)
                                .storeCategoryList
                                .map(
                                  (e) => InkWell(
                                    onTap: () async {
                                      setState(() {
                                        _setAllLoading = true;
                                      });
                                      await Provider.of<CustomerOffersProvider>(
                                              context,
                                              listen: false)
                                          .setStoreCatProducts(e.storeCatId);
                                      setState(() {
                                        _setAllLoading = false;
                                      });
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${Utilities.baseImgUrl}${e.storeCatImg}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        width: 220,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                                    Colors.black
                                                        .withOpacity(.5),
                                                    Colors.black
                                                        .withOpacity(.2),
                                                  ]),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                            child: Text(
                                              e.storeCatName,
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
                                    ),
                                  ),

                                  //     Container(
                                  //   width: 220,
                                  //   margin: EdgeInsets.symmetric(horizontal: 5),
                                  //   decoration: BoxDecoration(
                                  //       image: DecorationImage(
                                  //         image: NetworkImage(
                                  //             "${Utilities.baseImgUrl}${e.storeCatImg}"),
                                  //         fit: BoxFit.cover,
                                  //       ),
                                  //       borderRadius:
                                  //           BorderRadius.circular(18)),
                                  //   child: Center(
                                  //     child: Text(
                                  //       e.storeCatName,
                                  //       style: TextStyle(
                                  //           color: Colors.white,
                                  //           fontSize: 20,
                                  //           fontWeight: FontWeight.bold),
                                  //     ),
                                  //   ),
                                  // ),
                                )
                                .toList()
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _setAllLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Provider.of<CustomerOffersProvider>(context)
                                      .offersList
                                      .length ==
                                  0
                              ? Center(
                                  child: Text("No products available").tr(),
                                )
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount:
                                      Provider.of<CustomerOffersProvider>(
                                              context)
                                          .offersList
                                          .length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 2.5,
                                          childAspectRatio: .6,
                                          mainAxisSpacing: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return OfferProductWidget(
                                        Provider.of<CustomerOffersProvider>(
                                                context)
                                            .offersList[index]);
                                  },
                                )
                    ],
                  ),
          ),
        )));
  }
}
