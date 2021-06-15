import 'package:flutter/material.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/widgets/main_button.dart';

class ProductUploadedSuccessfullScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.all(60),
              child: Center(
                child: Image.asset(
                  'assets/checkgreen.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Your product has been uploaded successfully",
                textAlign: TextAlign.center,
                style: kHeadingTextStype,
              ),
            )),
            SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
              "Your payment method is now available",
              textAlign: TextAlign.center,
              style: kSubHeadingTextStyle,
            )),
            Center(
                child: Text(
              "So you can start enjoying  the offers!",
              textAlign: TextAlign.center,
              style: kSubHeadingTextStyle,
            )),
            MainButton(
              title: "See my products",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();

                  // Navigator.push(
                  //     context,
                  //     PageTransition(
                  //         type: PageTransitionType.leftToRight,
                  //         child: StoreManagerScreen()));
                },
                child: Text(
                  "See my profile",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                )),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ));
  }
}
