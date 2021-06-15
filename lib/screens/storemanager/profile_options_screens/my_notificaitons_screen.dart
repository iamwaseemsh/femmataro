import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:spain_project/utils/utilities.dart';

class MyNotifcationsScreen extends StatefulWidget {
  final String type;
  final String id;
  MyNotifcationsScreen({this.type, this.id});
  @override
  _MyNotifcationsScreenState createState() => _MyNotifcationsScreenState();
}

class _MyNotifcationsScreenState extends State<MyNotifcationsScreen> {
  List notifications = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifications();
  }

  getNotifications() async {
    EasyLoading.show(status: 'loading..', maskType: EasyLoadingMaskType.black);
    Map data;
    if (widget.type == 'cus') {
      data = {"userEmail": widget.id};
    } else {
      data = {"storeId": widget.id};
    }
    String api = "storeNotifications.php";
    if (widget.type == 'cus') {
      api = "getAllUserNotifications.php";
    }
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}${api}", form: {"userEmail": widget.id});
    Logger().i(response);
    setState(() {
      if (widget.type == 'cus') {
        notifications = response['userNotifications'];
      } else {
        notifications = response['storeNotifications'];
      }
    });
    EasyLoading.dismiss();
  }

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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            "My notifications",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          child: ListView(
            children: [
              Divider(
                height: 1,
                color: Colors.black38.withOpacity(.2),
              ),
              ...notifications
                  .map((e) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      "${e['notification']}",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: e['status'] == 'read'
                                              ? FontWeight.w300
                                              : FontWeight.bold),
                                    ),
                                  )),
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
        ));
  }
}
