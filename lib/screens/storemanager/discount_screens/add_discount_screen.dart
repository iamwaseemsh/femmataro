import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/providers/discount_providers.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/screens/payment_successfull_screen.dart';
import 'package:spain_project/screens/storemanager/home_screen.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/form_field_widget.dart';
import 'package:spain_project/widgets/main_button.dart';

class AddDiscountScreen extends StatefulWidget {
  @override
  _AddDiscountScreenState createState() => _AddDiscountScreenState();
}

class _AddDiscountScreenState extends State<AddDiscountScreen> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  DateTime selectedDate;
  var parsedDate;
  bool _loading = false;
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
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Text(
                  "Add your discount code".tr(),
                  style: kHeadingTextStype,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 70,
              ),
              FormFieldWidget(
                label: 'Name of code'.tr(),
                hint: 'XXXXXXXX',
                controller: _codeController,
              ),
              FormFieldWidget(
                label: 'Discount %',
                hint: '000%',
                isNumber: true,
                controller: _discountController,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Expiration date ",
                style: TextStyle(
                    color: Colors.black.withOpacity(.8),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 7,
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Row(
                  children: [
                    Text("Choose date").tr(),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(Icons.calendar_today),
                    SizedBox(
                      width: 5,
                    ),
                    if (selectedDate != null) Text(parsedDate)
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              ),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : MainButton(
                      title: "Add".tr(),
                      onPressed: () async {
                        if (_codeController.text.isEmpty) {
                          return Utilities.showSnackBar(
                              context, 'Name should not be empty'.tr());
                        }
                        if (_discountController.text.isEmpty) {
                          return Utilities.showSnackBar(context,
                              'Discount value should not be empty'.tr());
                        }
                        if (selectedDate == null) {
                          return Utilities.showSnackBar(
                              context, 'Date should not be empty'.tr());
                        }
                        if (Provider.of<DiscountProvider>(context,
                                listen: false)
                            .ifDiscountCodeAlreadyExists(
                                _codeController.text.toLowerCase().trim())) {
                          return Utilities.showSnackBar(
                              context, 'Discount Code already exists'.tr());
                        }
                        setState(() {
                          _loading = true;
                        });
                        final result = await Provider.of<DiscountProvider>(
                                context,
                                listen: false)
                            .addDiscount({
                          "discountCode": _codeController.text,
                          "discountPercent": _discountController.text,
                          "discountExpiry": selectedDate.toString(),
                          "storeId":
                              Provider.of<StoreProvider>(context, listen: false)
                                  .store
                                  .storeId
                        });
                        setState(() {
                          _loading = false;
                        });
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: PaymentSuccessfullScreen(
                                  title1: "Go to my products".tr(),
                                  title2: "See my profile".tr(),
                                  heading:
                                      "Your discount code has been added successfully"
                                          .tr(),
                                  onPressed1: (ctx) {
                                    Navigator.pushReplacement(
                                        ctx,
                                        PageTransition(
                                            type:
                                                PageTransitionType.leftToRight,
                                            child: StoreManagerScreen()));
                                  },
                                  onPressed2: (ctx) {
                                    Navigator.of(ctx).pop();
                                    Navigator.of(ctx).pop();
                                  },
                                  subItems: [
                                    "Your discount offer is added now!".tr()
                                  ],
                                )));

                        // Navigator.of(context).pop();
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        var outputFormat = DateFormat('MM/dd/yyyy');
        parsedDate = outputFormat.format(picked);
        selectedDate = picked;
        print(selectedDate);
      });
  }
}
