import 'dart:convert' as JSON;

// import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/models/user_model.dart';
import 'package:spain_project/networking/registration.dart';
import 'package:spain_project/providers/customer_providers.dart';
import 'package:spain_project/providers/user_provider.dart';
import 'package:spain_project/providers/wishlist_provider.dart';
import 'package:spain_project/screens/auth/phone_number_screen.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:spain_project/screens/user_type_screen.dart';
import 'package:spain_project/utils/shared_pref_services.dart';
import 'package:spain_project/utils/utilities.dart';

import '../pdf_videw_screen.dart';

class SocialSignInScreen extends StatefulWidget {
  @override
  _SocialSignInScreenState createState() => _SocialSignInScreenState();
}

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

class _SocialSignInScreenState extends State<SocialSignInScreen> {
  //new fb login testing
  bool _agree = false;
  bool canReceiveInfo = false;
  Map<String, dynamic> _userData;
  AccessToken _accessToken;
  bool _checking = true;

  void _printCredentials() {
    print(_accessToken.toJson());
  }

  Future<void> _login() async {
    // await _logOut();
    try {
      final LoginResult result = await FacebookAuth.instance
          .login(); // by the fault we request the email and the public profile
      if (result.status == LoginStatus.success) {
        _accessToken = result.accessToken;
        _printCredentials();
        // get the user data
        // by default we get the userId, email,name and picture
        final userData = await FacebookAuth.instance.getUserData();

        // final userData = await FacebookAuth.instance
        //     .getUserData(fields: "email,birthday,friends,gender,link");
        print(userData);
        _userData = userData;

        onSignInSuccess(userData['name'], userData['email'],
            userData['picture']['data']['url']);
      } else {
        print("hello");
        print(result.status);
        print(result.message);
        print(result.accessToken);
      }
    } catch (e) {
      Logger().i(e);
    }

    setState(() {
      _checking = false;
    });
  }

  Future<void> _logOut() async {
    Logger().i(await FacebookAuth.instance.accessToken);
    await FacebookAuth.instance.logOut();
  }

  //new fb login testing

  GoogleSignInAccount _currentUser;
  bool _isLoggedIn = false;
  Map userProfile;
  // final facebookLogin = FacebookLogin();
  setLogout() async {
    await _googleSignIn.disconnect();
  }

  Future onSignInSuccess(String name, String email, String imgUrl) async {
    // _logOut();
    // setLogout();
    final user = {"email": email, "name": name, "imgUrl": imgUrl};

    String data = JSON.jsonEncode(user);

    Provider.of<UserProvider>(context, listen: false)
        .signInUser(UserModel(name: name, email: email, imgUrl: imgUrl));
    await Provider.of<CustomerOffersProvider>(context, listen: false)
        .userLocationStatus(email);
    await Provider.of<WishListProvider>(context, listen: false)
        .getAndSetWishListFromPref(email);
    final ifAlreadyExists = await Registration.checkIfUserExists(email);
    EasyLoading.dismiss();
    if (await FacebookAuth.instance.accessToken != null) {
      await FacebookAuth.instance.logOut();
    } else if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    if (ifAlreadyExists == true) {
      await SharedPrefServices.setStringValue('user', data);
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.leftToRight, child: UserTypeScreen()));
    } else {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.leftToRight,
              child: PhoneNumberScreen(email, name, imgUrl)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setLogout();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      if (account != null) {
        onSignInSuccess(account.displayName, account.email, account.photoUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
          child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/backgroundprimary.png'),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Text(
                        "Don't look for deals, let them find you!",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 25),
                      ).tr(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Wrap(
                        runSpacing: 3,
                        // alignment: WrapAlignment.center,
                        children: [
                          SizedBox(
                            height: 19,
                            width: 18,
                            child: Checkbox(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: canReceiveInfo,
                                onChanged: (value) {
                                  setState(() {
                                    canReceiveInfo = value;
                                  });
                                }),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 7),
                              child: Text("I want to receive advertising and")
                                  .tr()),
                          Text('promotions')
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Wrap(
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
                                  color: kPrimaryColor,
                                  decoration: TextDecoration.underline),
                            ).tr(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_agree == false) {
                          return Utilities.showSnackBar(context,
                              'Accept the terms and conditions to proceed further');
                        }
                        _handleSignIn();
                      },
                      label: Text(
                        "Continue with Google",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ).tr(),
                      icon: ImageIcon(
                        AssetImage('assets/googlelogo.png'),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          primary: kButtonPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_agree == false) {
                          return Utilities.showSnackBar(context,
                              'Accept the terms and conditions to proceed further');
                        }
                        _login();
                      },
                      label: Text(
                        "Continue with Facebook",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ).tr(),
                      icon: ImageIcon(
                        AssetImage('assets/facebooklogo.png'),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          primary: kButtonPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              context.setLocale(Locale('en'));
                              print(context.fallbackLocale);
                            },
                            child: Text(
                              "English",
                              style: TextStyle(color: Colors.deepPurple),
                            )),
                        TextButton(
                            onPressed: () {
                              context.setLocale(Locale('es'));
                            },
                            child: Text(
                              "española",
                              style: TextStyle(color: Colors.redAccent),
                            )),
                        TextButton(
                            onPressed: () {
                              context.setLocale(Locale('ca'));
                            },
                            child: Text(
                              "Català",
                              style: TextStyle(color: Colors.redAccent),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      EasyLoading.show(status: 'Loading...');
      await _googleSignIn.signIn();
      EasyLoading.dismiss();
    } catch (error) {
      EasyLoading.dismiss();
    }
  }
}
