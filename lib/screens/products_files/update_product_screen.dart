import 'dart:async';
import 'dart:io';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/models/discount_model.dart';
import 'package:spain_project/models/new_product_image_model.dart';
import 'package:spain_project/models/product_category_model.dart';
import 'package:spain_project/providers/discount_providers.dart';
import 'package:spain_project/providers/store_product_provider.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/form_field_widget.dart';
import 'package:spain_project/widgets/main_button.dart';
import 'package:uuid/uuid.dart';

class UpdateProductScreen extends StatefulWidget {
  final String proId;
  UpdateProductScreen(this.proId);
  @override
  _UpdateProductScreenState createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  bool _uploadLoading = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _category;
  String _offer;
  var product;
  bool _loading = true;
  File _img1;
  File _img2;
  File _img3;
  File _img4;
  File _img5;
  List<NewProductImageModel> _productImages = [];
  final picker = ImagePicker();
  List<ProductCategoryModel> categories = [];
  List<DiscountModel> offers = [];
  List<String> oldImagesNames = [];
  Future setImage() async {
    oldImagesNames = [];
    print(product);
    // _cameraFile = await getImageFileFromAssets("camera.png");
    // _productImages.add(NewProductImageModel(image: _cameraFile, ifImg: false));
    if (product['proImg1'].length == 0) {
      oldImagesNames.add("${product['proImg1']}");
      _img1 = await getImageFileFromAssets("camera.png");
    } else {
      oldImagesNames.add(product['proImg1'].split('/').last);
      _img1 = await _fileFromImageUrl(product['proImg1'], "1");
    }

    _productImages
        .add(NewProductImageModel(ifImg: false, image: _img1, no: "1"));
    if (product['proImg2'].length == 0) {
      _img2 = await getImageFileFromAssets("camera.png");
      oldImagesNames.add("${product['proImg2']}");
    } else {
      oldImagesNames.add(product['proImg2'].split('/').last);
      _img2 = await _fileFromImageUrl(product['proImg2'], "2");
    }

    _productImages
        .add(NewProductImageModel(ifImg: false, image: _img2, no: "2"));

    if (product['proImg3'].length == 0) {
      oldImagesNames.add("/${product['proImg3']}");
      _img3 = await getImageFileFromAssets("camera.png");
    } else {
      oldImagesNames.add("${product['proImg3'].split('/').last}");
      _img3 = await _fileFromImageUrl(product['proImg3'], "3");
    }

    _productImages
        .add(NewProductImageModel(ifImg: false, image: _img3, no: "3"));

    if (product['proImg4'].length == 0) {
      oldImagesNames.add("${product['proImg4']}");
      _img4 = await getImageFileFromAssets("camera.png");
    } else {
      oldImagesNames.add("${product['proImg4'].split('/').last}");
      _img4 = await _fileFromImageUrl(product['proImg4'], "4");
    }

    _productImages
        .add(NewProductImageModel(ifImg: false, image: _img4, no: "4"));

    if (product['proImg5'].length == 0) {
      oldImagesNames.add("${product['proImg5']}");
      _img5 = await getImageFileFromAssets("camera.png");
    } else {
      oldImagesNames.add(product['proImg5'].split('/').last);
      _img5 = await _fileFromImageUrl(product['proImg5'], "5");
    }

    _productImages
        .add(NewProductImageModel(ifImg: false, image: _img5, no: "5"));
    Logger().i(oldImagesNames);
  }

  Future<File> _fileFromImageUrl(String url, String name) async {
    final response = await http.get(Uri.parse("${url}"));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(
        join(documentDirectory.path, '${Uuid().v4()}.${name.split(".").last}'));
    file.writeAsBytesSync(response.bodyBytes);
    return file;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  getProduct() async {
    Logger().i(widget.proId);
    final response = await Utilities.getPostRequestData(
        url: '${Utilities.baseUrl}productDetails.php',
        form: {"proId": widget.proId.toString()});

    product = response['productDetails'][0];
    _category = product['proCatId'];
    _offer = product['discountId'];

    await setImage();
    _nameController.text = product['proName'];
    _descriptionController.text = product['proDesc'];
    _priceController.text = product['proPrice'].toStringAsFixed(2);
    await Provider.of<DiscountProvider>(this.context, listen: false)
        .getAndSetDiscount(
        Provider.of<StoreProvider>(this.context, listen: false)
            .store
            .storeId);

    await Provider.of<StoreProductProvider>(this.context, listen: false)
        .getAndSetCategoreis(
        Provider.of<StoreProvider>(this.context, listen: false)
            .store
            .storeCatId);
    offers =
        Provider.of<DiscountProvider>(this.context, listen: false).discountList;
    categories = Provider.of<StoreProductProvider>(this.context, listen: false)
        .productCategoriestList;
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("hello");
    getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          "Update Product",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          if (_loading == false)
            TextButton(
                onPressed: () async {
                  if (await confirm(
                    context,
                    title: Text("Confirm"),
                    content: Text("Are you sure"),
                    textOK: Text('Yes'),
                    textCancel: Text('No'),
                  )) {
                    String storeId =
                        Provider.of<StoreProvider>(context, listen: false)
                            .store
                            .storeId;
                    await Provider.of<StoreProductProvider>(context,
                            listen: false)
                        .deleteProduct(widget.proId, storeId);
                    Utilities.showSnackBar(
                        context, "Product moved to trash bin");
                    Timer(Duration(seconds: 2), () {
                      Navigator.of(context).pop();
                    });
                  }
                },
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ))
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
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
                                                        e.image = e.no == "1"
                                                            ? _img1
                                                            : e.no == '2'
                                                                ? _img2
                                                                : e.no == '3'
                                                                    ? _img3
                                                                    : e.no ==
                                                                            '4'
                                                                        ? _img4
                                                                        : e.no ==
                                                                                '5'
                                                                            ? _img5
                                                                            : null;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                      size: 21,
                                                    ),
                                                  ),
                                                )
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
                      label: "Product Name",
                      hint: "Name",
                      controller: _nameController,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Choose Product Category",
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
                            hint: Text("Choose categories"),
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
                      label: "Price",
                      hint: "Number",
                      isNumber: true,
                      controller: _priceController,
                    ),
                    FormFieldWidget(
                      label: "Complete description",
                      hint: "Description",
                      isDescription: true,
                      controller: _descriptionController,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Offers",
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
                            hint: Text("Choose an offer"),
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
                    _uploadLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : MainButton(
                            title: "Update Product",
                            onPressed: () async {
                              if (_nameController.text.isEmpty) {
                                return Utilities.showSnackBar(
                                    context, 'Name should not be empty');
                              } else if (_priceController.text.isEmpty) {
                                return Utilities.showSnackBar(
                                    context, 'Price should not be zero');
                              } else if (_descriptionController.text.isEmpty) {
                                return Utilities.showSnackBar(
                                    context, 'Description should not be empty');
                              }
                              setState(() {
                                _uploadLoading = true;
                              });

                              String storeId = Provider.of<StoreProvider>(
                                      context,
                                      listen: false)
                                  .store
                                  .storeId;

                              await Provider.of<StoreProductProvider>(context,
                                      listen: false)
                                  .updateAnProduct(
                                      name: _nameController.text,
                                      catId: _category,
                                      description: _descriptionController.text,
                                      storeId: storeId,
                                      price: _priceController.text,
                                      files: _productImages,
                                      offerId: _offer,
                                      proId: widget.proId,
                                      oldImages: oldImagesNames);

                              setState(() {
                                _uploadLoading = false;
                              });
                              Navigator.of(context).pop();

                              // Navigator.pushReplacement(
                              //     context,
                              //     PageTransition(
                              //         type: PageTransitionType.bottomToTop,
                              //         child: ProductUploadedSuccessfullScreen()));
                            },
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}
