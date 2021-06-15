import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spain_project/screens/storemanager/account_screen_store.dart';
import 'package:spain_project/screens/storemanager/products_screen_store.dart';
import 'package:spain_project/screens/storemanager/sells_screen_store.dart';

class StoreManagerScreen extends StatefulWidget {
  @override
  _StoreManagerScreenState createState() => _StoreManagerScreenState();
}

class _StoreManagerScreenState extends State<StoreManagerScreen> {
  int _currentIndex = 0;
  List<Widget> screens = [
    ProductsScreenStore(),
    // ExploreScreenStore(),
    // NewScreenStore(),
    MyBillsScreen(),
    AccountScreenStore()
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              Visibility(
                  visible: _currentIndex == 0,
                  maintainState: true,
                  child: ProductsScreenStore()),
              Visibility(
                  visible: _currentIndex == 1,
                  maintainState: true,
                  child: MyBillsScreen()),
              Visibility(
                  visible: _currentIndex == 2,
                  maintainState: false,
                  child: AccountScreenStore()),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            unselectedIconTheme: IconThemeData(color: Colors.black),
            selectedIconTheme: IconThemeData(color: Colors.lightBlueAccent),
            showUnselectedLabels: true,
            showSelectedLabels: true,
            selectedLabelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            selectedItemColor: Colors.lightBlueAccent,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/home/1.png')),
                  label: "Products".tr()),
              // BottomNavigationBarItem(
              //     icon: ImageIcon(AssetImage('assets/home/2.png')),
              //     label: "Explore".tr()),
              // BottomNavigationBarItem(
              //     icon: ImageIcon(AssetImage('assets/home/3.png')),
              //     label: "New".tr()),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/home/4.png')),
                  label: "Sells".tr()),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/home/5.png')),
                  label: "Account".tr()),
            ],
          ),
        ),
      ),
    );
  }
}
