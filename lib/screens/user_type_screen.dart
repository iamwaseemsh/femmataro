import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/customer_side/customer_home_screen.dart';
import 'package:spain_project/networking/registration.dart';
import 'package:spain_project/providers/customer_providers.dart';
import 'package:spain_project/screens/auth/store_manager_register.dart';
import 'package:spain_project/screens/my_pick_up_address_screen.dart';
import 'package:spain_project/screens/stores_list_screen.dart';
import 'package:spain_project/utils/shared_pref_services.dart';
import 'package:spain_project/widgets/main_button.dart';

class UserTypeScreen extends StatefulWidget {
  // bool
  @override
  _UserTypeScreenState createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  final _globalKey = GlobalKey();
  Uint8List pngBytes;
  File captureImg;
  bool storeLoading = false;
  bool customerLoading = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/backgroundprimary.png'),
                    fit: BoxFit.cover)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 120,
                ),
                Text(
                  "Are you Store Manager or Customer?",
                  style: kHeadingTextStype,
                ).tr(),
                SizedBox(
                  height: 30,
                ),
                storeLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : MainButton(
                        title: "Store Manager".tr(),
                        onPressed: () async {
                          await EasyLoading.show(
                              status: 'loading..',
                              maskType: EasyLoadingMaskType.black);

                          // setState(() {
                          //   storeLoading = true;
                          // });
                          final user = await SharedPrefServices.getValue(
                              'user', 'String');
                          final decodedUser = jsonDecode(user);

                          final result =
                              await Registration.checkIfStoreManagerExists(
                                  decodedUser['email']);

                          if (result == false) {
                            EasyLoading.dismiss();
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: StoreManagerRegistrationScreen()));
                          } else {
                            final isVerified =
                                await Registration.chechIfCifIsVerified();

                            if (isVerified == true) {
                              // setState(() {
                              //   storeLoading = false;
                              // });
                              EasyLoading.dismiss();
                              return Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.leftToRight,
                                      child: StoresListScreen()));
                            }
                            // setState(() {
                            //   storeLoading = false;
                            // });
                            EasyLoading.dismiss();
                            EasyLoading.showInfo(
                                'Please wait your CIF is being verified.',
                                duration: Duration(seconds: 2));
                          }
                        },
                      ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "- Or -",
                      style: kHeadingTextStype.copyWith(fontSize: 18),
                    ).tr(),
                  ),
                ),
                MainButton(
                  title: "Customer".tr(),
                  onPressed: () {
                    if (Provider.of<CustomerOffersProvider>(context,
                                listen: false)
                            .userLocationStatusValue ==
                        false) {
                      return Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              child: MyPickUpScreen(type: 2)));
                    }
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.topToBottom,
                            child: CustomerHomeScreen()));
                  },
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime returnYMDFromDateTime(DateTime date) {
    var parsed = DateTime.parse(date.toString());
    var newDate = new DateTime(parsed.year, parsed.month, parsed.day);
    return newDate;
  }

  DateTime returnDateTimeFromString(String date) {
    var newDate = new DateTime(int.parse(date.split('/')[0]),
        int.parse(date.split('/')[1]), int.parse(date.split('/')[2]));
    return newDate;
  }
}
