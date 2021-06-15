import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/models/user_model.dart';
import 'package:spain_project/networking/registration.dart';
import 'package:spain_project/providers/user_provider.dart';
import 'package:spain_project/screens/auth/social_signin_screen.dart';
import 'package:spain_project/screens/user_type_screen.dart';
import 'package:spain_project/utils/shared_pref_services.dart';

class VerifyPinScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;
  final String name;
  final String imgUrl;
  VerifyPinScreen({this.phoneNumber, this.email, this.name, this.imgUrl});
  @override
  _VerifyPinScreenState createState() => _VerifyPinScreenState();
}

class _VerifyPinScreenState extends State<VerifyPinScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.keyboard_arrow_left),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Insert the code you received on your phone".tr(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) async {
                  print(value);
                  if (value.length == 6) {
                    await FirebaseAuth.instance
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: _verificationCode, smsCode: value))
                        .then((value) async {
                      final result = await Registration.registerUser(
                          widget.phoneNumber, widget.name, widget.email);
                      if (result == true) {
                        final user = {
                          "email": widget.email,
                          "name": widget.name,
                          "imgUrl": widget.imgUrl
                        };

                        String data = jsonEncode(user);
                        await SharedPrefServices.setStringValue('user', data);
                        Provider.of<UserProvider>(context, listen: false)
                            .signInUser(UserModel(
                                name: widget.name,
                                email: widget.email,
                                imgUrl: widget.imgUrl));
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (c) => SocialSignInScreen()),
                            (route) => false);

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (ctox) => UserTypeScreen()));
                      }

                      //
                      // Navigator.pushReplacement(
                      //     context,
                      //     PageTransition(
                      //         type: PageTransitionType.leftToRight,
                      //         child: UserTypeScreen()));
                    });
                  }
                },
                decoration: InputDecoration(
                    labelText: "Code".tr(), hintText: "- - - - -"),
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: VerifyPinScreen(
                                    phoneNumber: widget.phoneNumber,
                                    email: widget.email,
                                    name: widget.name,
                                  )));
                        },
                        child: Text(
                          "Resend the code".tr(),
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        )),
                    // InkWell(
                    //   child: CircleAvatar(
                    //     child: IconButton(
                    //         icon: Icon(Icons.arrow_forward_ios_rounded),
                    //         onPressed: () {
                    //           Navigator.push(
                    //               context,
                    //               PageTransition(
                    //                   type: PageTransitionType.leftToRight,
                    //                   child: UserTypeScreen()));
                    //         }),
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${widget.phoneNumber}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            final result = await Registration.registerUser(
                widget.phoneNumber, widget.name, widget.email);
            if (result == true) {
              final user = {
                "email": widget.email,
                "name": widget.name,
                "imgUrl": widget.imgUrl
              };

              String data = jsonEncode(user);
              await SharedPrefServices.setStringValue('user', data);
              Provider.of<UserProvider>(context, listen: false).signInUser(
                  UserModel(
                      name: widget.name,
                      email: widget.email,
                      imgUrl: widget.imgUrl));
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (c) => SocialSignInScreen()),
                  (route) => false);

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctox) => UserTypeScreen()));
            }

            //if token is verified
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print("failde message");
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.phoneNumber);
    super.initState();
    _verifyPhone();
  }
}
