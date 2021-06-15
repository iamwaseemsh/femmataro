import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/models/user_model.dart';
import 'package:spain_project/providers/cart_provider.dart';
import 'package:spain_project/providers/customer_providers.dart';
import 'package:spain_project/providers/user_provider.dart';
import 'package:spain_project/providers/wishlist_provider.dart';
import 'package:spain_project/screens/auth/social_signin_screen.dart';
import 'package:spain_project/screens/user_type_screen.dart';
import 'package:spain_project/screens/welcome_screen.dart';
import 'package:spain_project/services/starting_app_services.dart';
import 'package:spain_project/utils/shared_pref_services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  configureApp() async {
    bool isWelcomeScreen = await StartingServices.isWelcomeScreen();
    // final user = await SharedPrefServices.getValue('user', "String");
    String yesterDayDate =
        await SharedPrefServices.getValue('yesterDayDate', 'String');
    DateTime now = DateTime.now();
    var dateParse = DateTime.parse(now.toString());
    if (yesterDayDate.isEmpty) {
      Logger().i('Date was empty');
      now = DateTime(dateParse.year, dateParse.month, dateParse.day);
      await SharedPrefServices.setStringValue(
          'yesterDayDate', "${now.year}/${now.month}/${now.day}");
    } else {
      DateTime lastDate = returnDateTimeFromString(yesterDayDate);

      if (returnYMDFromDateTime(DateTime.now()).isAfter(lastDate)) {
        List<String> value = [];
        await SharedPrefServices.setListValue(
            name: 'cartItemsList', values: value);
        await SharedPrefServices.setStringValue(
            'yesterDayDate', "${now.year}/${now.month}/${now.day}");
      }
    }

    final user = await SharedPrefServices.getCurrentUser();
    await Provider.of<CustomerOffersProvider>(context, listen: false)
        .getAndSetHomeData();
    if (!user.isEmpty) {
      await Provider.of<WishListProvider>(context, listen: false)
          .getAndSetWishListFromPref(user['email']);
    }
    await Provider.of<CartProvider>(context, listen: false).getAndSetItems();

    Timer(Duration(seconds: 0), () async {
      if (isWelcomeScreen == true) {
        if (user.length < 1) {
          return Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: SocialSignInScreen()));
        }
        await Provider.of<CustomerOffersProvider>(context, listen: false)
            .userLocationStatus(user['email']);

        Provider.of<UserProvider>(context, listen: false).signInUser(UserModel(
            name: user['name'], email: user['email'], imgUrl: user['imgUrl']));
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: UserTypeScreen()));
      } else {
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRight, child: WelcomeScreen()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    configureApp();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                  width: 100,
                  child: Center(
                    child: Image.asset(
                      'assets/splashlogo.png',
                      fit: BoxFit.contain,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
