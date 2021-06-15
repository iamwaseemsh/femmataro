class WishListItemModel {
  final String proId;
  final String proImg;
  final String proDesc;
  final String storeId;
  final String storeName;
  final String proPrice;
  final String proName;
  final String discountPercent;
  WishListItemModel(
      {this.proDesc,
      this.proPrice,
      this.proId,
      this.proImg,
      this.storeId,
      this.storeName,
      this.proName,
      this.discountPercent});
  Map<String, dynamic> toMap() {
    return {
      'proId': proId,
      'proImg': proImg,
      "proDesc": proDesc,
      "storeId": storeId,
      "storeName": storeName,
      "proPrice": proPrice,
      "proName": proName,
      "discountPercent": discountPercent
    };
  }
}
