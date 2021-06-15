import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/screens/auth/verify_pin_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  String email;
  String name;
  String imgUrl;

  PhoneNumberScreen(this.email, this.name, this.imgUrl);
  @override
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  TextEditingController _controller = TextEditingController();
  bool isError = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              "Insert your phone number".tr(),
              style: kHeadingTextStype,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Phone number".tr(),
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                errorText:
                    isError ? "Phone number shouldn't be empty".tr() : null,
                // prefix: Text("+34"),
                // prefixText: "+34",
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/spain.png',
                    scale: 1.5,
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                child: CircleAvatar(
                  radius: 30,
                  child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: () async {
                        final result = await FacebookAuth.instance.accessToken;
                        if (result != null) {
                          await FacebookAuth.instance.logOut();
                        }

                        if (_controller.text.length == 0) {
                          setState(() {
                            isError = true;
                          });
                          return;
                        }

                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: VerifyPinScreen(
                                    phoneNumber: _controller.text,
                                    email: widget.email,
                                    name: widget.name,
                                    imgUrl: widget.imgUrl)));
                      }),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    ));
  }
}
