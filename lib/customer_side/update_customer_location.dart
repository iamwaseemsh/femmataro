import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/form_field_widget.dart';
import 'package:spain_project/widgets/main_button.dart';

class UpdateUserLocation extends StatefulWidget {
  final String userEmail;
  UpdateUserLocation({this.userEmail});
  @override
  _UpdateUserLocationState createState() => _UpdateUserLocationState();
}

class _UpdateUserLocationState extends State<UpdateUserLocation> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCode = TextEditingController();
  getLocation() async {
    EasyLoading.show(status: 'loading..', maskType: EasyLoadingMaskType.black);
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}getStoreTokenizationKey.php",
        form: {"userEmail": widget.userEmail});
    setState(() {
      _addressController.text = response['userAddress'];
      _postalCode.text = response['postalCode'];
    });
    Logger().i(response);
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
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
      body: Container(
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
                'Select my location'.tr(),
                style: kHeadingTextStype,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Update your location to receive the offers of the shops of Mataro"
                    .tr(),
                style: kSubHeadingTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              FormFieldWidget(
                controller: _addressController,
                label: "Where do you live?".tr(),
                hint: "Address".tr(),
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
                  Utilities.showLoading();

                  Map userLocData = {
                    "userTypedAddress": _addressController.text,
                    "userTypedPostalCode": _postalCode.text,
                  };
                  // final response = await Utilities.getPostRequestData(
                  //     url: '${Utilities.baseUrl}updateUserLocation.php',
                  //     form: {
                  //       "userEmail": widget.userEmail,
                  //       "location": jsonEncode(userLocData)
                  //     });
                  await Provider.of<StoreProvider>(context, listen: false)
                      .getAndSetStores();
                  EasyLoading.dismiss();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
