import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/models/customer/cart_item_model.dart';
import 'package:spain_project/models/customer/product_details_model.dart';
import 'package:spain_project/models/customer/wishlist_item_model.dart';
import 'package:spain_project/providers/wishlist_provider.dart';
import 'package:spain_project/screens/photo_view_screen.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/main_button.dart';

import '../providers/cart_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  String proId;
  ProductDetailsScreen(this.proId);
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool showReviewList = false;
  ProductDetailsModel product;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndSetProduct();
  }

  getAndSetProduct() async {
    String id = widget.proId;
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}returnSingleProductDetails.php",
        form: {"proId": id});
    Logger().i(response);
    List<String> temp = [];
    if (response['productDetails'][0]['proImg1'].length != 0) {
      temp.add(response['productDetails'][0]['proImg1']);
    }
    if (response['productDetails'][0]['proImg2'].length != 0) {
      temp.add(response['productDetails'][0]['proImg2']);
    }
    if (response['productDetails'][0]['proImg3'].length != 0) {
      temp.add(response['productDetails'][0]['proImg3']);
    }
    if (response['productDetails'][0]['proImg4'].length != 0) {
      temp.add(response['productDetails'][0]['proImg4']);
    }
    if (response['productDetails'][0]['proImg5'].length != 0) {
      temp.add(response['productDetails'][0]['proImg5']);
    }

    product = ProductDetailsModel(
        proId: response['productDetails'][0]['proId'],
        proDesc: response['productDetails'][0]['proDesc'],
        storeName: response['productDetails'][0]['storeName'],
        proPrice: response['productDetails'][0]['proPrice'].toString(),
        productImgs: temp,
        proName: response['productDetails'][0]['proName'],
        storeId: response['productDetails'][0]['storeId'],
        starRating: response['productDetails'][0]['starRating'].toDouble() ?? 0,
        discountPercent:
            response['productDetails'][0]['discountPercent'].toString(),
        reviews: response["productReviews"]);

    Logger().i(response);

    setState(() {
      loading = false;
    });
  }

  int qty = 1;
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.black54,
            ),
            onPressed: () async {
              Share.share(
                  'Hey! checkout this course **** on this app https://play.google.com/store/apps/details?id=com.bism.linedrawapp',
                  subject: 'LineDraw');
            },
          )
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView(
                children: [
                  Container(
                    height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Carousel(
                        borderRadius: true,
                        dotSize: 4,
                        autoplayDuration: Duration(seconds: 20),
                        dotBgColor: Colors.transparent,
                        dotColor: kGreyTextColor,
                        dotPosition: DotPosition.bottomCenter,
                        radius: Radius.circular(10),
                        dotSpacing: 8,
                        dotIncreasedColor: kPrimaryColor,
                        overlayShadow: false,
                        images: [
                          ...product.productImgs
                              .map((e) => InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) => PhotoViewScreen(
                                                  "${Utilities.baseImgUrl}$e")));
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Hero(
                                          tag: 'image',
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
                                      ),
                                    ),
                                  ))
                              .toList()
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          child: Text(
                            product.proName,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        )),
                        Container(
                          child: IconButton(
                            onPressed: () {
                              Provider.of<WishListProvider>(context,
                                      listen: false)
                                  .addWishListItem(WishListItemModel(
                                      proDesc: product.proDesc,
                                      proId: product.proId,
                                      proImg: product.productImgs[0],
                                      proName: product.proName,
                                      proPrice: product.proPrice,
                                      storeId: product.storeId,
                                      storeName: product.storeName,
                                      discountPercent:
                                          product.discountPercent));
                            },
                            icon: Icon(
                              Provider.of<WishListProvider>(context)
                                          .checkIfItemExists(product.proId) ==
                                      true
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: kGreyTextColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      child: Text(
                        "${product.storeName}",
                        style: TextStyle(fontSize: 24, color: Colors.black54),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (qty > 1) {
                                    setState(() {
                                      qty = qty - 1;
                                    });
                                  }
                                },
                                icon: Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: Icon(
                                    Icons.minimize,
                                    color: qty == 1
                                        ? Colors.black54
                                        : kPrimaryColor,
                                  ),
                                )),
                            Card(
                              shape: RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.black12, width: 1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Container(
                                width: 40,
                                height: 40,
                                child: Center(
                                    child: Text(
                                  "${qty}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22),
                                )),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    qty = qty + 1;
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: kPrimaryColor,
                                )),
                          ],
                        ),
                        Text(
                          "${product.proPrice}€",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Divider(
                      height: 2,
                      color: Colors.black54,
                    ),
                  ),
                  // TextButton(
                  //     onPressed: () async {
                  //       final response = await SharedPrefServices.getListValue(
                  //           name: 'wishlist');
                  //       for (var item in response) {
                  //         Map data = jsonDecode(item);
                  //         Logger().i(data);
                  //       }
                  //     },
                  //     child: Text("check")),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Details".tr(),
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(product.proDesc),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          child: Divider(
                            height: 2,
                            color: Colors.black54,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Review".tr(),
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Expanded(child: Container()),
                            Container(
                              child: RatingBar.builder(
                                initialRating: product.starRating,
                                updateOnDrag: true,
                                direction: Axis.horizontal,
                                // tapOnlyMode: true,
                                itemSize: 20,
                                allowHalfRating: true,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemCount: 5,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.deepOrangeAccent,
                                ),
                              ),
                            ),
                            IconButton(
                                icon: Icon(!showReviewList
                                    ? Icons.keyboard_arrow_right
                                    : Icons.keyboard_arrow_down_rounded),
                                onPressed: () {
                                  setState(() {
                                    showReviewList = !showReviewList;
                                  });
                                })
                          ],
                        ),
                        if (showReviewList)
                          ...product.reviews
                              .map((review) => Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.all(2),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              review['userName'],
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12),
                                            ),
                                            Text("  ${review['reviewDate']}",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 10)),
                                            Expanded(child: Container()),
                                            RatingBar.builder(
                                              initialRating: double.parse(
                                                  review['userRating']),
                                              updateOnDrag: true,
                                              direction: Axis.horizontal,
                                              // tapOnlyMode: true,
                                              itemSize: 11,
                                              allowHalfRating: true,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: .5),
                                              itemCount: 5,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.deepOrangeAccent,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          review['proReview'],
                                          style: TextStyle(fontSize: 18),
                                        )
                                      ],
                                    ),
                                  ))
                              .toList()
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: MainButton(
                      title: "Add to cart".tr(),
                      onPressed: () async {
                        await Provider.of<CartProvider>(context, listen: false)
                            .addCartItem(CartItemModel(
                                proId: product.proId,
                                proImg: product.productImgs[0],
                                proName: product.proName,
                                proPrice: product.proPrice,
                                storeName: product.storeName,
                                storeId: product.storeId,
                                disoucntPercent: product.discountPercent,
                                qty: qty));
                        Utilities.showSnackBar(
                            context, "Item added to cart".tr());
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
