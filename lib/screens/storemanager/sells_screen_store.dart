import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/providers/bills_provider.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/screens/storemanager/bills_screens/my_bills_sub_screen.dart';
import 'package:spain_project/screens/storemanager/bills_screens/my_sales_sub_screen.dart';
import 'package:spain_project/screens/storemanager/bills_screens/my_statistics_sub_screen.dart';
import 'package:spain_project/utils/utilities.dart';

class MyBillsScreen extends StatefulWidget {
  final String storeId;
  MyBillsScreen({this.storeId});
  @override
  _MyBillsScreenState createState() => _MyBillsScreenState();
}

class _MyBillsScreenState extends State<MyBillsScreen> {
  List<Widget> _screen = [
    MyBillsSubScreen(),
    MySalesSubScreen(),
    MyStatisticsSubScreen()
  ];
  int _selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getAndSet() async {
    await EasyLoading.show(
        status: 'loading..', maskType: EasyLoadingMaskType.black);
    Logger().w("heelo1 ");
    final storeId =
        Provider.of<StoreProvider>(context, listen: false).store.storeId;
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}getSalesReport.php",
        form: {"storeId": storeId});
    Logger().w("heelo2 ");
    Logger().i(response);
    Provider.of<BillsProvider>(context, listen: false)
        .setBills(response['subscriptions']);
    Provider.of<BillsProvider>(context, listen: false)
        .setHistoryList(response['salesRecord']);
    Provider.of<BillsProvider>(context, listen: false)
        .setStatList(response['monthlySales']);
    Provider.of<BillsProvider>(context, listen: false)
        .setTotalSale(response['totalOrderAmount'].toStringAsFixed(2));

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
        backgroundColor: Colors.white.withOpacity(.5),
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
        centerTitle: true,
        title: Text(
          _selectedIndex == 0
              ? "My Bills"
              : _selectedIndex == 1
                  ? "My Sales"
                  : "My Statistics",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: RefreshIndicator(
          onRefresh: ()async{
       await getAndSet();
        },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: _selectedIndex == 0
                                ? Border.all(color: Colors.black, width: 1)
                                : null,
                            borderRadius: BorderRadius.circular(15)),
                        height: 70,
                        child: Image.asset(
                          'assets/account/bills1.png',
                          fit: BoxFit.cover,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: _selectedIndex == 1
                                ? Border.all(color: Colors.black, width: 1)
                                : null,
                            borderRadius: BorderRadius.circular(15)),
                        height: 70,
                        child: Image.asset(
                          'assets/account/bills2.png',
                          fit: BoxFit.cover,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: _selectedIndex == 2
                                ? Border.all(color: Colors.black, width: 1)
                                : null,
                            borderRadius: BorderRadius.circular(15)),
                        height: 70,
                        child: Image.asset(
                          'assets/account/bills3.png',
                          fit: BoxFit.cover,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _screen[_selectedIndex])
            ],
          ),
        ),
      ),
    );
  }
}
