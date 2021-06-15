import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/screens/storemanager/home_screen.dart';
import 'package:spain_project/widgets/main_button.dart';
class PaymentSuccessfullScreen extends StatelessWidget {
  final List<String> subItems;
  final String heading;
  final String title1;
  final String title2;
  final Function onPressed1;
  final Function onPressed2;
  PaymentSuccessfullScreen({this.onPressed1,this.onPressed2,this.subItems,this.title1,this.title2,this.heading});
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
                child: Image.asset('assets/checkgreen.png',fit: BoxFit.cover,),
              ),
            ),
            SizedBox(height: 20,),
            Center(child: Text(heading,textAlign: TextAlign.center,style: kHeadingTextStype,)),
            SizedBox(height: 20,),
            ...subItems.map((e) => Center(child: Text(e,textAlign: TextAlign.center,style: kSubHeadingTextStyle,))).toList(),
            // Center(child: Text("Your subscription has been accepted and is now available to upload your offers!",textAlign: TextAlign.center,style: kSubHeadingTextStyle,)),
            // Center(child: Text("You received an e-mail with the invoice details of your payment",textAlign: TextAlign.center,style: kSubHeadingTextStyle,)),

            SizedBox(height: 50,),
            MainButton(title: title1,onPressed: (){
              onPressed1(context);
            },),
            TextButton(onPressed: (){
              onPressed2(context);}, child: Text(title2,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),)),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}