import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/providers/store_product_provider.dart';

class FaqsScreen extends StatefulWidget {
  @override
  _FaqsScreenState createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  bool loading = true;
  List<FaqsModel> _faqs = [];
  getAndSetData() async {
    await Provider.of<StoreProductProvider>(context, listen: false)
        .getAndSetFaqsList();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAndSetData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: .4,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "Help FAQS".tr(),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...Provider.of<StoreProductProvider>(context)
                        .faqsList
                        .map((e) => FaqWidget(e))
                        .toList()
                  ],
                ),
              ),
            ),
    );
  }
}

class FaqWidget extends StatefulWidget {
  FaqsModel faq;
  FaqWidget(this.faq);
  @override
  _FaqWidgetState createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: EdgeInsets.only(bottom: 1),
            child: ListTile(
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              title: Text(widget.faq.question),
              trailing: Icon(expanded
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.arrow_forward_ios_rounded),
            ),
          ),
          if (expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Text(
                    "Answer".tr(),
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    ": ${widget.faq.answer}",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class FaqsModel {
  final String question;
  final String answer;
  FaqsModel({this.answer, this.question});
}
