import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/providers/bills_provider.dart';

class MyBillsSubScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Divider(
            height: 1,
            color: Colors.black38.withOpacity(.2),
          ),
          ...Provider.of<BillsProvider>(context)
              .billsHistoryList
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
                                      child: Text(
                                "${e.text}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 20),
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
    );
  }
}
