class StoreProductModel {
  final String proCatName;
  final String proPrice;
  final String proId;
  final String proName;
  final String discountCode;
  final String discountPercent;
  final String discountExpiry;
  final String proImg;
  StoreProductModel(
      {this.proCatName,
      this.proId,
      this.proName,
      this.proPrice,
      this.discountCode,
      this.discountPercent,
        this.proImg,
      this.discountExpiry});
}
