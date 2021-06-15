class OfferProductModel {
  String proId;
  String proImg;
  String storeName;
  String proName;
  String proPrice;
  String discountPercent;
  String storeId;
  OfferProductModel(
      {this.proPrice,
      this.proId,
      this.proImg,
      this.storeName,
      this.proName,
      this.storeId,
      this.discountPercent});
}

class StoreCategoryModel {
  String storeCatImg;
  String storeCatName;
  String storeCatId;
  StoreCategoryModel({this.storeCatName, this.storeCatImg, this.storeCatId});
}

class ProductCategoryModel {
  String proCatId;
  String proCatName;
  String proCatImgUrl;
  ProductCategoryModel({this.proCatName, this.proCatId, this.proCatImgUrl});
}
