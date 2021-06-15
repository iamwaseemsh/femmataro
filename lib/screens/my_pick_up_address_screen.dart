import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/customer_side/customer_home_screen.dart';
import 'package:spain_project/providers/customer_providers.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/utils/shared_pref_services.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/form_field_widget.dart';
import 'package:spain_project/widgets/main_button.dart';

class MyPickUpScreen extends StatefulWidget {
  int type;
  MyPickUpScreen({this.type});
  @override
  _MyPickUpScreenState createState() => _MyPickUpScreenState();
}

class _MyPickUpScreenState extends State<MyPickUpScreen> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCode = TextEditingController();
  Map userLocation;
  bool loading = true;
  LocationData currentLocation;
  Address userAddress;

  Future getUserLocation() async {
    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        Utilities.showSnackBar(context, 'Please allow permissions');
        return Navigator.of(context).pop();
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        Utilities.showSnackBar(
            context, 'Permission denied- please enable it from app settings');
        return Navigator.of(context).pop();
        print(error);
      } else {
        Utilities.showSnackBar(
            context, 'Error occured during getting position. Try again!.');
        return Navigator.of(context).pop();
        myLocation = null;
      }
    }
    currentLocation = myLocation;
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    print(coordinates);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    userAddress = addresses.first;
    var first = addresses.first;
    final currentUser = await SharedPrefServices.getCurrentUser();

    Map userLocData = {
      "longitude": currentLocation.longitude,
      "latitude": currentLocation.latitude,
      "province": userAddress.adminArea,
      "city": userAddress.locality,
      "other1": userAddress.featureName,
    };
    final response = await Utilities.getPostRequestData(
        url: '${Utilities.baseUrl}updateUserLocation.php',
        form: {
          "userEmail": currentUser['email'],
          "location": jsonEncode(userLocData)
        });
    if (response['message'] == true) {
      EasyLoading.dismiss();
      Provider.of<CustomerOffersProvider>(context, listen: false)
          .userLocationStatusValue = true;
      Utilities.showSnackBar(context, 'Your location is updated');
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.leftToRight,
              child: CustomerHomeScreen()));
    } else {
      EasyLoading.dismiss();
      Utilities.showSnackBar(context, 'Error updating location! Try again.');
    }

    print(
        ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    // print(first.adminArea);  // Punjab
    // print(first.locality); // Bhakkar
    // print(first.addressLine);  //full address
    // print(first.subAdminArea); //  bhakkar
    // print(first.featureName);//muhallah chumni
    // print(first.coordinates.latitude);
    // print(first.postalCode);

    Logger().i(userLocation);
    setState(() {
      loading = false;
    });
  }

  getStorePreviousLocation() async {
    final storeId =
        Provider.of<StoreProvider>(context, listen: false).store.storeId;
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}getStoreAddress.php",
        form: {"storeId": storeId});
    Logger().i(response);
    _addressController.text = response['address'];
    _postalCode.text = response['postalCode'];
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == 1) {
      Logger().i('hello');
      // getUserLocation();
      getStorePreviousLocation();
    } else {
      getUserLocation();
    }
  }

  setLoadingFalse() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(.3),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Center(
                        child: Image.asset(
                          'assets/location.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      widget.type == 1
                          ? "Select my pick up\n address".tr()
                          : 'Select my location'.tr(),
                      style: kHeadingTextStype,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.type == 1
                          ? "Activate your location to see where\nis your pick up address store\n address."
                              .tr()
                          : "Activate your location to receive the offers of the shops of Mataro"
                              .tr(),
                      style: kSubHeadingTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    FormFieldWidget(
                      controller: _addressController,
                      label: widget.type == 1
                          ? "Where is your store located?".tr()
                          : "Where do you live?".tr(),
                      hint: "Address",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FormFieldWidget(
                      label: "Postal Code".tr(),
                      hint: "Number".tr(),
                      controller: _postalCode,
                      isNumber: true,
                    ),
                    MainButton(
                      title: "Update".tr(),
                      onPressed: () async {
                        if (_addressController.text.isEmpty ||
                            _postalCode.text.isEmpty) {
                          return Utilities.showSnackBar(
                              context, 'Please fill in al the fields'.tr());
                        }
                        EasyLoading.show(status: 'Loading...');
                        final currentUser =
                            await SharedPrefServices.getCurrentUser();

                        Map userLocData = {
                          "longitude": currentLocation.longitude,
                          "latitude": currentLocation.latitude,
                          "province": userAddress.adminArea,
                          "city": userAddress.locality,
                          "other1": userAddress.featureName,
                        };
                        final response = await Utilities.getPostRequestData(
                            url: '${Utilities.baseUrl}updateUserLocation.php',
                            form: {
                              "userEmail": currentUser['email'],
                              "location": jsonEncode(userLocData)
                            });
                        if (response['message'] == true) {
                          EasyLoading.dismiss();
                          Provider.of<CustomerOffersProvider>(context,
                                  listen: false)
                              .userLocationStatusValue = true;
                          Utilities.showSnackBar(
                              context, 'Your location is updated');
                          Timer(Duration(seconds: 1), () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: CustomerHomeScreen()));
                          });
                        } else {
                          EasyLoading.dismiss();
                          Utilities.showSnackBar(
                              context, 'Error updating location! Try again.');
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
