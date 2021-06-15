import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/models/address_model.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/form_field_widget.dart';
import 'package:spain_project/widgets/main_button.dart';

class UpdateStoreAddress extends StatefulWidget {
  @override
  _UpdateStoreAddressState createState() => _UpdateStoreAddressState();
}

class _UpdateStoreAddressState extends State<UpdateStoreAddress> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCode = TextEditingController();

  getStorePreviousLocation() async {
    Utilities.showLoading();

    final storeId =
        Provider.of<StoreProvider>(context, listen: false).store.storeId;
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}getStoreAddress.php",
        form: {"storeId": storeId});
    Logger().i(response);
    setState(() {
      _addressController.text = response['address'];
      _postalCode.text = response['postalCode'];
    });
    EasyLoading.dismiss();
  }

  setPreviusLocations() {
    setState(() {
      _addressController.text =
          Provider.of<StoreProvider>(context, listen: false)
              .storeAdress
              .address;
      _postalCode.text = Provider.of<StoreProvider>(context, listen: false)
          .storeAdress
          .postalCode;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setPreviusLocations();
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
                "Select my pick up address",
                style: kHeadingTextStype,
                textAlign: TextAlign.center,
              ).tr(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Activate your location to see where is your pick up address store address.",
                  style: kSubHeadingTextStyle,
                  textAlign: TextAlign.center,
                ).tr(),
              ),
              SizedBox(
                height: 40,
              ),
              FormFieldWidget(
                controller: _addressController,
                label: "Where is your store located?".tr(),
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

                  Map data = {
                    "storeAddress": _addressController.text,
                    "postalCode": _postalCode.text,
                    "storeId":
                        Provider.of<StoreProvider>(context, listen: false)
                            .store
                            .storeId
                  };
                  final response = await Utilities.getPostRequestData(
                      url: '${Utilities.baseUrl}updateStoreAddress.php',
                      form: data);
                  Provider.of<StoreProvider>(context, listen: false)
                      .updateStoreAddress(AddressModel(
                    address: _addressController.text,
                    postalCode: _postalCode.text,
                  ));
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
