import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spain_project/screens/change_language_screen.dart';
import 'package:spain_project/utils/shared_pref_services.dart';
import 'package:spain_project/widgets/main_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/welcomeimage.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 70,
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Welcome to FEM Mataró".tr(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat'),
            ),
            Text(
              "Your store network in Mataró".tr(),
              style: TextStyle(color: Colors.white38, fontSize: 17),
            ),
            SizedBox(
              height: 30,
            ),
            MainButton(
              title: "Start".tr(),
              onPressed: () async {
                await SharedPrefServices.setBoolValue('isWelcomeScreen', true);

                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: ChangeLanguageScreen(isWel: true)));
              },
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    ));
  }
}
