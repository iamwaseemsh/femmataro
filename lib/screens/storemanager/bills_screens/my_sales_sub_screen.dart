import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/constants/constants.dart';
import 'package:spain_project/providers/bills_provider.dart';

class MySalesSubScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Divider(
                  height: 1,
                  color: Colors.black38.withOpacity(.2),
                ),
                ...Provider.of<BillsProvider>(context)
                    .salesHistoryList
                    .map((e) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Container(
                                height: 100,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Center(
                                            child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Order".tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 20),
                                        ),
                                        Text(
                                          " ${e.orderId}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ))),
                                    Expanded(
                                        child: Container(
                                      child: Center(
                                          child: Text(
                                        "€${e.amount}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )),
                                    ))
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                color: Colors.black38.withOpacity(.2),
                              ),
                            ],
                          ),
                        ))
                    .toList()
              ],
            ),
          ),
          Container(
            height: 60,
            decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(.1),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "Total Sales: €${Provider.of<BillsProvider>(context).totalSales}",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
