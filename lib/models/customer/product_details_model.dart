class ProductDetailsModel {
  List<String> productImgs = [];
  final String storeId;
  final String storeName;
  final String proId;
  final String proName;
  final String proDesc;
  final String proPrice;
  final String discountPercent;
  final double starRating;
  final List<dynamic> reviews;

  ProductDetailsModel(
      {this.proId,
      this.storeId,
      this.storeName,
      this.proName,
      this.proDesc,
      this.productImgs,
      this.proPrice,
      this.discountPercent,
      this.starRating,
      this.reviews});
}
