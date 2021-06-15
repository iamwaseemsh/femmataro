import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:logger/logger.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/main_button.dart';

class GiveRatingScreen extends StatefulWidget {
  final String userEmail;
  final String proId;
  final String orderId;
  GiveRatingScreen({this.userEmail, this.proId, this.orderId});
  @override
  _GiveRatingScreenState createState() => _GiveRatingScreenState();
}

class _GiveRatingScreenState extends State<GiveRatingScreen> {
  bool reviewLoading = false;
  TextEditingController _message = TextEditingController();
  double rating = 5;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Rate product".tr(),
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Tell us about the product".tr(),
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Divider(
                height: 3,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Your rating".tr(),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              RatingBar.builder(
                initialRating: rating,
                updateOnDrag: true,
                direction: Axis.horizontal,
                // tapOnlyMode: true,
                itemSize: MediaQuery.of(context).size.width / 7,
                allowHalfRating: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                itemCount: 5,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value;
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: _message,
                minLines: 10,
                maxLines: 12,
                decoration: InputDecoration(
                  labelText: "Message".tr(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              reviewLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : MainButton(
                      title: "Submit".tr(),
                      onPressed: () async {
                        if (_message.text.isEmpty) {
                          return Utilities.showSnackBar(
                              context, "Please write a review".tr());
                        }
                        Utilities.showLoading();
                        final reponse = await Utilities.getPostRequestData(
                            url: "${Utilities.baseUrl}userRating.php",
                            form: {
                              "starRating": rating.toString(),
                              "userEmail": widget.userEmail,
                              "proId": widget.proId,
                              "review": _message.text,
                              "orderId": widget.orderId
                            });
                        Logger().i(reponse);
                        EasyLoading.dismiss();
                        Navigator.of(context).pop(true);
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
