import 'package:flutter/material.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/widgets/main_button.dart';

class PaymentAcceptedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Text(
              'Your order has been accepted',
              textAlign: TextAlign.center,
              style: kHeadingTextStype,
            )),
            SizedBox(
              height: 20,
            ),
            // ...subItems
            //     .map((e) => Center(
            //             child: Text(
            //           e,
            //           textAlign: TextAlign.center,
            //           style: kSubHeadingTextStyle,
            //         )))
            //     .toList(),
            Center(
                child: Text(
              "Items paid successfully",
              textAlign: TextAlign.center,
              style: kSubHeadingTextStyle,
            )),
            Center(
                child: Text(
              "and we are managing your order",
              textAlign: TextAlign.center,
              style: kSubHeadingTextStyle,
            )),

            SizedBox(
              height: 50,
            ),
            MainButton(
              title: 'Track Your order',
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'My Profile',
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
    );
  }
}
