import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/models/category_model.dart';
import 'package:spain_project/networking/registration.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/form_field_widget.dart';

import '../../constants/constants.dart';
import '../../widgets/main_button.dart';
import '../pdf_videw_screen.dart';

class AddNewStore extends StatefulWidget {
  @override
  _AddNewStoreState createState() => _AddNewStoreState();
}

class _AddNewStoreState extends State<AddNewStore> {
  final picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _confirmEmailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  bool _loading = true;
  bool _agree = false;
  bool uploadLoading = false;
  List<CategoryModel> categories = [];
  String _category;
  LocationData currentLocation;
  String catId;
  File _storeImage;
  File _storeLogo;
  Future getUserLocation() async {
    //call this async method from whereever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        Utilities.showSnackBar(context, 'Please allow permissions'.tr());
        return Navigator.of(context).pop();
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings'.tr();
        Utilities.showSnackBar(context,
            'Permission denied- please enable it from app settings'.tr());
        return Navigator.of(context).pop();
        print(error);
      } else {
        Utilities.showSnackBar(
            context, 'Error occured during getting position. Try again!.'.tr());
        return Navigator.of(context).pop();
        myLocation = null;
      }
    } catch (e) {
      Utilities.showSnackBar(
          context, 'Error occured during getting position. Try again!.'.tr());
      return Navigator.of(context).pop();
    }
    currentLocation = myLocation;

    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    print(coordinates);

    try {
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;

      return first;
    } catch (e) {
      Utilities.showSnackBar(
          context, 'Error occured during getting position. Try again!.'.tr());
      return Navigator.of(context).pop();
    }
  }

  getAndSetScreen() async {
    categories = await Registration.getStoreCategories();
    _category = categories[0].catId;

    await getUserLocation();
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EasyLoading.showInfo('Please make sure you are present in your store'.tr(),
        dismissOnTap: true);

    getAndSetScreen();
  }

  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            height: 70,
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.cover,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                            child: Text(
                          "Add new store".tr(),
                          style: kHeadingTextStype,
                        )),
                        SizedBox(
                          height: 20,
                        ),
                        FormFieldWidget(
                          label: "Store's Name".tr(),
                          hint: "Name".tr(),
                          controller: _nameController,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Choose Store Category".tr(),
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
                                hint: Text("Choose categories".tr()),
                                items: categories
                                    .map((e) => DropdownMenuItem(
                                          child: Text(e.catName),
                                          value: e.catId,
                                        ))
                                    .toList(),
                                value: _category,
                                onChanged: (String value) {
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
                          label: "Email".tr(),
                          hint: "mataroni@labotiga.com",
                          controller: _emailController,
                        ),
                        FormFieldWidget(
                          label: "Confirm Email".tr(),
                          hint: "mataroni@labotiga.com",
                          controller: _confirmEmailController,
                        ),
                        FormFieldWidget(
                          label: "Address".tr(),
                          hint: "Store's address".tr(),
                          controller: _addressController,
                        ),
                        FormFieldWidget(
                          label: "Postal Code".tr(),
                          hint: "Postal code".tr(),
                          controller: _postalCodeController,
                          isNumber: true,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        InkWell(
                          onTap: () async {
                            var image = await ImagePicker().getImage(
                                source: ImageSource.gallery, imageQuality: 50);
                            if (image != null) {
                              setState(() {
                                _storeImage = File(image.path);
                              });
                            }
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.cloud_upload_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Upload Store Image").tr()
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            var image = await ImagePicker().getImage(
                                source: ImageSource.gallery, imageQuality: 50);
                            if (image != null) {
                              setState(() {
                                _storeLogo = File(image.path);
                              });
                            }
                          },
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.cloud_upload_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Upload Store Logo").tr()
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          runSpacing: 3,
                          // alignment: WrapAlignment.center,
                          children: [
                            SizedBox(
                              height: 19,
                              width: 18,
                              child: Checkbox(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: _agree,
                                  onChanged: (value) {
                                    setState(() {
                                      _agree = value;
                                    });
                                  }),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 7),
                                child: Text("I agree to the").tr()),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.topToBottom,
                                        child: PdfViewScreen(
                                            context.locale.toString())));
                              },
                              child: Text(
                                " Terms & Conditions".tr(),
                                style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    decoration: TextDecoration.underline),
                              ).tr(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        uploadLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : MainButton(
                                title: "Add".tr(),
                                onPressed: () async {
                                  if (_nameController.text.isEmpty) {
                                    return Utilities.showSnackBar(context,
                                        'Store name should not be empty'.tr());
                                  } else if (_emailController.text.isEmpty) {
                                    return Utilities.showSnackBar(context,
                                        'Email should not be empty'.tr());
                                  }  else if (_emailController.text!=_confirmEmailController.text) {
                                    return Utilities.showSnackBar(context,
                                        'Email and Confirm email do not match'.tr());
                                  } else if (_addressController.text.isEmpty) {
                                    return Utilities.showSnackBar(context,
                                        'Address should not be empty'.tr());
                                  } else if (_postalCodeController
                                      .text.isEmpty) {
                                    return Utilities.showSnackBar(context,
                                        'Postal code should not be empty'.tr());
                                  } else if (_storeImage == null) {
                                    return Utilities.showSnackBar(context,
                                        'Please select a store image'.tr());
                                  } else if (_storeLogo == null) {
                                    return Utilities.showSnackBar(context,
                                        'Please select a store logo'.tr());
                                  } else if (_agree == false) {
                                    return Utilities.showSnackBar(
                                        context,
                                        'You must agree to terms & conditions'
                                            .tr());
                                  }
                                  Utilities.showLoading();

                                  final result =
                                      await Registration.registerStore(
                                          storeEmail: _emailController.text,
                                          storeName: _nameController.text,
                                          address: _addressController.text,
                                          postalCode:
                                              _postalCodeController.text,
                                          catId: _category,
                                          lati: currentLocation.latitude
                                              .toString(),
                                          storeImage: _storeImage,
                                          storeLogo: _storeLogo,
                                          longi: currentLocation.longitude
                                              .toString());

                                  await Provider.of<StoreProvider>(context,
                                          listen: false)
                                      .getAndSetStores();
                                  EasyLoading.dismiss();
                                  EasyLoading.showSuccess(
                                      'Store created successfully'.tr(),
                                      dismissOnTap: true);
                                  Navigator.of(context).pop(true);
                                },
                              ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      )),
    );
  }
}
