import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/models/customer/cart_item_model.dart';
import 'package:spain_project/models/customer/wishlist_item_model.dart';
import 'package:spain_project/providers/wishlist_provider.dart';

import '../../providers/cart_provider.dart';
import '../../utils/utilities.dart';
import '../../widgets/main_button.dart';

class CustomerFavouriteScreen extends StatefulWidget {
  @override
  _CustomerFavouriteScreenState createState() =>
      _CustomerFavouriteScreenState();
}

class _CustomerFavouriteScreenState extends State<CustomerFavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Wishlist".tr(),
            style: TextStyle(color: Colors.black87),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: .8,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: ListView(
                children: [
                  ...Provider.of<WishListProvider>(context)
                      .wishListItems
                      .map((e) => Container(
                            // color: Colors.orange,
                            padding: EdgeInsets.only(
                              left: 10,
                              bottom: 3,
                            ),
                            height: 145,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.black38),
                                    onPressed: () {
                                      Provider.of<WishListProvider>(context,
                                              listen: false)
                                          .addWishListItem(WishListItemModel(
                                        proDesc: e.proDesc,
                                        proId: e.proId,
                                      ));
                                    },
                                  ),
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 70,
                                        height: 70,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${Utilities.baseImgUrl}${e.proImg}',
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            e.proName,
                                            style: TextStyle(fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          AutoSizeText(
                                            "${e.proDesc}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                // fontSize: 14,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "€${e.proPrice}   ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 22),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Divider(
                                  height: 2,
                                  thickness: 1,
                                )
                              ],
                            ),
                          ))
                ],
              )),
              if (Provider.of<WishListProvider>(context).wishListItems.length >
                  0)
                MainButton(
                  title: "Add All To Cart".tr(),
                  onPressed: () {
                    for (var item
                        in Provider.of<WishListProvider>(context, listen: false)
                            .wishListItems) {
                      Provider.of<CartProvider>(context, listen: false)
                          .addCartItem(CartItemModel(
                              proId: item.proId,
                              proImg: item.proImg,
                              proName: item.proName,
                              proPrice: item.proPrice,
                              storeName: item.storeName,
                              storeId: item.storeId,
                              disoucntPercent: item.discountPercent,
                              qty: 1));
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("All items add to the cart").tr()));
                  },
                ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
