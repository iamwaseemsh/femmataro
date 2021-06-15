import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spain_project/networking/registration.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/form_field_widget.dart';

import '../../constants/constants.dart';
import '../../widgets/main_button.dart';

class StoreManagerRegistrationScreen extends StatefulWidget {
  @override
  _StoreManagerRegistrationScreenState createState() =>
      _StoreManagerRegistrationScreenState();
}

class _StoreManagerRegistrationScreenState
    extends State<StoreManagerRegistrationScreen> {
  File _cliImage;
  var _filePath;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _cifController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final picker = ImagePicker();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Register as\nSTORE MANAGER",
                  textAlign: TextAlign.center,
                  style: kHeadingTextStype,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Active your store location in Mataró",
                  textAlign: TextAlign.center,
                  style: kSubHeadingTextStyle,
                ),
              ),
              SizedBox(
                height: 70,
              ),
              FormFieldWidget(
                hint: "Name and Surname",
                label: "Name and Surname",
                controller: _nameController,
              ),
              FormFieldWidget(
                hint: "BXXXXXXXXXX",
                label: "CIF",
                controller: _cifController,
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  var file = await picker.getImage(
                      source: ImageSource.camera, imageQuality: 20);
                  if (file != null) {
                    _cliImage = File(file.path);
                  }
                },
                child: Row(
                  children: [
                    Text("Choose the picture of CIF document"),
                    Expanded(child: Container()),
                    Icon(Icons.cloud_upload_outlined)
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              MainButton(
                title: "Register",
                onPressed: () async {
                  if (_nameController.text.isEmpty) {
                    return Utilities.showSnackBar(
                        context, 'Name should not be empty');
                  }
                  if (_cifController.text.isEmpty) {
                    return Utilities.showSnackBar(
                        context, 'CIF should not be empty');
                  } else if (_cliImage == null) {
                    return Utilities.showSnackBar(
                        context, 'Image should not be empty');
                  }
                  EasyLoading.show(status: 'Loading...');

                  final result = await Registration.StoreManagerRegisteration(
                      _nameController.text, _cifController.text, _cliImage);
                  final res = jsonDecode(result);
                  if (res['message'] == true) {
                    EasyLoading.dismiss();
                    Utilities.showSnackBar(
                        context, 'Please wait you CIF is being verified');
                  }
                  Timer(Duration(seconds: 1), () {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
