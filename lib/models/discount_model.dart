class DiscountModel{
  final String discountId;
  final String discountCode;
  final String discountPercent;
  final String discountExpiry;
  DiscountModel({this.discountCode,this.discountExpiry,this.discountPercent,this.discountId});
  // Map<String, dynamic> toMap() {
  //   return {
  //     'codeName': storeName,
  //     'storeAddress':storeAddress,
  //     "storeId":storeId
  //
  //   };
  // }
}