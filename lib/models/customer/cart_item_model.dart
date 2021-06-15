class CartItemModel {
  final String proId;
  final String proImg;
  final String storeId;
  final String storeName;
  final String proPrice;
  final String proName;
  int qty;
  final String disoucntPercent;
  CartItemModel(
      {this.proPrice,
      this.proId,
      this.proImg,
      this.storeId,
      this.storeName,
      this.qty,
      this.proName,
      this.disoucntPercent});
  Map<String, dynamic> toMap() {
    return {
      'proId': proId,
      'proImg': proImg,
      "storeId": storeId,
      "storeName": storeName,
      "proPrice": proPrice,
      "proName": proName,
      "qty": "$qty",
      "disoucntPercent": disoucntPercent
    };
  }
}
