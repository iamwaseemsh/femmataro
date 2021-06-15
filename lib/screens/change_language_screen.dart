import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/providers/customer_providers.dart';
import 'package:spain_project/screens/auth/social_signin_screen.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/main_button.dart';

class ChangeLanguageScreen extends StatefulWidget {
  final bool isWel;
  ChangeLanguageScreen({this.isWel});
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  String _language;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(.3),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Center(
                child: Text(
                  "Select Your Language",
                  style: kHeadingTextStype,
                ),
              ),
            ),
            Container(
              child: DropdownButton<String>(
                iconEnabledColor: Colors.grey.withOpacity(.6),
                isExpanded: true,
                itemHeight: 50,
                iconSize: 30,
                hint: Text("Select your language"),
                items: ['Català', 'Español', 'English']
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                value: _language,
                onChanged: (String value) {
                  setState(() {
                    _language = value;
                  });
                },
              ),
            ),
            MainButton(
              title: 'Save your language',
              onPressed: () async {
                Utilities.showLoading();
                if (_language.isNotEmpty) {
                  String code;
                  if (_language == 'Català') {
                    code = 'ca';
                  } else if (_language == 'Español') {
                    code = 'es';
                  } else if (_language == 'English') {
                    code = 'en';
                  }
                  context.setLocale(Locale(code));
                  Utilities.setLanguageCode(code);
                  await Provider.of<CustomerOffersProvider>(context,
                          listen: false)
                      .setStoreCategories();
                  Utilities.dismissLoading();
                  if (widget.isWel != true) {
                    Navigator.of(context).pop();
                  }
                }
                if (widget.isWel == true) {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.leftToRight,
                          child: SocialSignInScreen()));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
