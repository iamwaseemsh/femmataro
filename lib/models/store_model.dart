class StoreModel {
  final String storeId;
  final String storeName;
  final String storeAddress;
  final String storeCatId;
  final String pendingOrders;
  StoreModel(
      {this.storeName,
      this.storeAddress,
      this.storeId,
      this.storeCatId,
      this.pendingOrders});

  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
      'storeAddress': storeAddress,
      "storeId": storeId,
      "pendingOrders": pendingOrders
    };
  }
}
