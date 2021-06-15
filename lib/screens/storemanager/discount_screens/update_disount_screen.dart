import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/providers/discount_providers.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/utils/utilities.dart';
import 'package:spain_project/widgets/form_field_widget.dart';
import 'package:spain_project/widgets/main_button.dart';

class UpdateDiscountScreen extends StatefulWidget {
  final String discountId;
  final String expiryDate;
  final String discountPercent;
  final String discountCode;
  UpdateDiscountScreen(
      {this.discountId,
      this.discountCode,
      this.discountPercent,
      this.expiryDate});
  @override
  _UpdateDiscountScreenState createState() => _UpdateDiscountScreenState();
}

class _UpdateDiscountScreenState extends State<UpdateDiscountScreen> {
  bool loading = true;
  TextEditingController _codeController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  DateTime selectedDate;
  var parsedDate;
  void setData() {
    _codeController.text = widget.discountCode;
    _discountController.text = widget.discountPercent;
    selectedDate = new DateFormat("yyyy-MM-dd").parse(widget.expiryDate);
    var outputFormat = DateFormat('MM/dd/yyyy');
    parsedDate = outputFormat.format(selectedDate);
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
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
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () async {
                if (await confirm(
                  context,
                  title: Text("Confirm"),
                  content: Text("Are you sure"),
                  textOK: Text('Yes'),
                  textCancel: Text('No'),
                )) {
                  String storeId =
                      Provider.of<StoreProvider>(context, listen: false)
                          .store
                          .storeId;
                  await Provider.of<DiscountProvider>(context, listen: false)
                      .deleteDiscount(widget.discountId, storeId);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ))
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Update your\ndiscount code",
                      style: kHeadingTextStype,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    FormFieldWidget(
                      label: 'Name of code',
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
                          Text("Choose date"),
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
                    MainButton(
                      title: "Update",
                      onPressed: () async {
                        if (_codeController.text.isEmpty) {
                          return Utilities.showSnackBar(
                              context, 'Name should not be empty');
                        }
                        if (_discountController.text.isEmpty) {
                          return Utilities.showSnackBar(
                              context, 'Discount should not be empty');
                        }
                        if (selectedDate == null) {
                          return Utilities.showSnackBar(
                              context, 'Date should not be empty');
                        }
                        final result = await Provider.of<DiscountProvider>(
                                context,
                                listen: false)
                            .updateDiscount({
                          "discountCode": _codeController.text,
                          "discountPercent": _discountController.text,
                          "discountExpiry": selectedDate.toString(),
                          "discountId": widget.discountId,
                          "storeId":
                              Provider.of<StoreProvider>(context, listen: false)
                                  .store
                                  .storeId
                        });
                        Navigator.of(context).pop();
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
