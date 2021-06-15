import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:spain_project/models/discount_model.dart';
import 'package:spain_project/models/new_product_image_model.dart';
import 'package:spain_project/models/product_category_model.dart';
import 'package:spain_project/providers/discount_providers.dart';
import 'package:spain_project/providers/store_product_provider.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/screens/storemanager/product_uploaded_successfully.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/form_field_widget.dart';
import 'package:spain_project/widgets/main_button.dart';

class CreateNewProductScreen extends StatefulWidget {
  @override
  _CreateNewProductScreenState createState() => _CreateNewProductScreenState();
}

class _CreateNewProductScreenState extends State<CreateNewProductScreen> {
  bool _loading = true;
  bool _uploadLoading = false;
  File _file;
  List<NewProductImageModel> _productImages = [];
  final picker = ImagePicker();
  List<ProductCategoryModel> categories = [];

  List<DiscountModel> offers = [];
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _category;
  String _offer;
  @override
  void initState() {
    print('helo');
    // TODO: implement initState
    super.initState();
    setOffers();
  }

  void setOffers() async {
    Logger().i('Starting getting discounts');
    await Provider.of<DiscountProvider>(context, listen: false)
        .getAndSetDiscount(
            Provider.of<StoreProvider>(context, listen: false).store.storeId);

    await Provider.of<StoreProductProvider>(context, listen: false)
        .getAndSetCategoreis(Provider.of<StoreProvider>(context, listen: false)
            .store
            .storeCatId);

    offers = Provider.of<DiscountProvider>(context, listen: false).discountList;
    categories = Provider.of<StoreProductProvider>(context, listen: false)
        .productCategoriestList;
    _category = categories[0].proCatId;
    _offer = offers[0].discountId;

    setImage();
  }

  void setImage() async {
    _file = await getImageFileFromAssets("camera.png");
    for (var i = 0; i < 5; i++) {
      _productImages.add(NewProductImageModel(image: _file, ifImg: false));
    }
    setState(() {
      _loading = false;
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Utilities.dismissLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white.withOpacity(.5),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            "New Product",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ..._productImages
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () async {
                                          var image = await ImagePicker()
                                              .getImage(
                                                  source: ImageSource.gallery,
                                                  imageQuality: 50);
                                          if (image != null) {
                                            setState(() {
                                              e.image = File(image.path);
                                              e.ifImg = true;
                                            });
                                          }
                                          print(e);
                                        },
                                        child: Container(
                                            height: 50,
                                            width: 50,
                                            child: Stack(
                                              overflow: Overflow.visible,
                                              children: [
                                                Image.file(
                                                  e.image,
                                                  fit: BoxFit.contain,
                                                ),
                                                if (e.ifImg)
                                                  Positioned(
                                                      right: -25,
                                                      top: -25,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              e.ifImg = false;
                                                              e.image = _file;
                                                            });
                                                          },
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors.red,
                                                            size: 21,
                                                          )))
                                              ],
                                            )),
                                      ),
                                    ))
                                .toList()
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FormFieldWidget(
                        label: "Product Name".tr(),
                        hint: "Name".tr(),
                        controller: _nameController,
                      ),
                      // FormFieldWidget(label: "Category",hint: "What is this?",),

                      //Store sub category e.g juices vegs
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Choose Product Category".tr(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black.withOpacity(.8),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: DropdownButton<String>(
                              iconEnabledColor: Colors.grey.withOpacity(.6),
                              isExpanded: true,
                              itemHeight: 50,
                              iconSize: 30,
                              hint: Text("Choose categories").tr(),
                              items: categories
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e.proCatName),
                                        value: e.proCatId,
                                      ))
                                  .toList(),
                              value: _category,
                              onChanged: (String value) {
                                print(_category);
                                setState(() {
                                  _category = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                      FormFieldWidget(
                        label: "Price".tr(),
                        hint: "Number".tr(),
                        isNumber: true,
                        controller: _priceController,
                      ),
                      FormFieldWidget(
                        label: "Complete description".tr(),
                        hint: "Description".tr(),
                        isDescription: true,
                        controller: _descriptionController,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Offers".tr(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black.withOpacity(.8),
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: DropdownButton<String>(
                              iconEnabledColor: Colors.grey.withOpacity(.6),
                              isExpanded: true,
                              itemHeight: 50,
                              iconSize: 30,
                              hint: Text("Choose an offer").tr(),
                              items: offers
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e.discountCode),
                                        value: e.discountId,
                                      ))
                                  .toList(),
                              value: _offer,
                              onChanged: (String value) {
                                setState(() {
                                  _offer = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                      // TextButton(onPressed: () {
                      //   List<DiscountModel> offer=offers.where((element) => element.discountCode==_discountCode).toList();
                      //   print(offer[0].discountId);
                      // }, child: Text("Get id")),

                      _uploadLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : MainButton(
                              title: "Uplaod Product".tr(),
                              onPressed: () async {
                                if (_nameController.text.isEmpty) {
                                  return Utilities.showSnackBar(
                                      context, 'Name should not be empty'.tr());
                                } else if (_priceController.text.isEmpty) {
                                  return Utilities.showSnackBar(
                                      context, 'Price should not be zero'.tr());
                                } else if (_descriptionController
                                    .text.isEmpty) {
                                  return Utilities.showSnackBar(context,
                                      'Description should not be empty'.tr());
                                }
                                var counter = 0;
                                for (var i = 0;
                                    i < _productImages.length;
                                    i++) {
                                  if (_productImages[i].ifImg == true) {
                                    counter++;
                                  }
                                }
                                if (counter == 0) {
                                  return Utilities.showSnackBar(context,
                                      'Choose at least one image'.tr());
                                }

                                Utilities.showLoading();

                                String storeId = Provider.of<StoreProvider>(
                                        context,
                                        listen: false)
                                    .store
                                    .storeId;
                                final response =
                                    await Provider.of<StoreProductProvider>(
                                            context,
                                            listen: false)
                                        .uploadnewProduct(
                                            name: _nameController.text,
                                            catId: _category,
                                            description:
                                                _descriptionController.text,
                                            storeId: storeId,
                                            price: _priceController.text,
                                            files: _productImages,
                                            offerId: _offer);

                                Utilities.dismissLoading();

                                if (response['message'] == 'Found') {
                                  return Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Error",
                                    desc:
                                        "Product name already found in this store."
                                            .tr(),
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ).tr(),
                                        onPressed: () => Navigator.pop(context),
                                        width: 120,
                                      )
                                    ],
                                  ).show();
                                }

                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child:
                                            ProductUploadedSuccessfullScreen()));
                              },
                            ),
                    ],
                  ),
                ),
              ),
      )),
    );
  }
}
