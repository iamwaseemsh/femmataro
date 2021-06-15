import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/customer_side/productDetailsScreen.dart';
import 'package:spain_project/models/customer/cart_item_model.dart';
import 'package:spain_project/models/customer/offers_list_models.dart';
import 'package:spain_project/utils/utilities.dart';

import '../providers/cart_provider.dart';
import '../utils/utilities.dart';

class OfferProductWidget extends StatelessWidget {
  OfferProductModel product;
  OfferProductWidget(this.product);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          print(product.proId);
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: ProductDetailsScreen(product.proId)));
        },
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl:
                                '${Utilities.baseImgUrl}${product.proImg}',
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(
                            right: 3, left: 3, bottom: 2, top: 1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 3,
                            ),
                            AutoSizeText(
                              "${product.proName}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Container(
                              height: 17,
                              child: AutoSizeText(
                                product.storeName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AutoSizeText(
                                    "€${product.proPrice}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 7, right: 7),
                                    child: InkWell(
                                      onTap: () async {
                                        await Provider.of<CartProvider>(context,
                                                listen: false)
                                            .addCartItem(CartItemModel(
                                                proId: product.proId,
                                                proImg: product.proImg,
                                                proName: product.proName,
                                                proPrice: product.proPrice,
                                                storeName: product.storeName,
                                                storeId: product.storeId,
                                                disoucntPercent:
                                                    product.discountPercent,
                                                qty: 1));
                                        Utilities.showSnackBar(
                                            context, "Item added to cart".tr());
                                      },
                                      child: Center(
                                        child: CircleAvatar(
                                          minRadius: 22,
                                          maxRadius: 24,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
            if (double.parse(product.discountPercent) > 0)
              Container(
                width: 42,
                height: 21,
                decoration: BoxDecoration(
                    color: Colors.deepOrange.withOpacity(.7),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        topLeft: Radius.circular(10))),
                child: Center(
                  child: Text(
                    "${product.discountPercent}% off",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
