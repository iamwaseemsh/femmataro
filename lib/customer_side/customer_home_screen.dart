import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/customer_side/home_sub/cus_cart_screen.dart';
import 'package:spain_project/customer_side/home_sub/cus_favourite_screen.dart';
import 'package:spain_project/customer_side/home_sub/cus_offers_screen.dart';
import 'package:spain_project/customer_side/home_sub/cus_profile_screen.dart';
import 'package:spain_project/customer_side/home_sub/cus_search_screen.dart';
import 'package:spain_project/providers/wishlist_provider.dart';

class CustomerHomeScreen extends StatefulWidget {
  @override
  _CustomerHomeScreenState createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  List<Widget> customerScreens = [
    CustomerOffersScreen(),
    CustomerSearchScreen(),
    CustomerCartScreen(),
    CustomerFavouriteScreen(),
    CustomerProfileScreen()
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                  child: CustomerOffersScreen()),
              Visibility(
                  visible: _currentIndex == 1,
                  maintainState: true,
                  child: CustomerSearchScreen()),
              Visibility(
                  visible: _currentIndex == 2,
                  maintainState: false,
                  child: CustomerCartScreen()),
              Visibility(
                  visible: _currentIndex == 3,
                  maintainState: true,
                  child: CustomerFavouriteScreen()),
              Visibility(
                  visible: _currentIndex == 4,
                  maintainState: false,
                  child: CustomerProfileScreen()),
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
              if (_currentIndex == 3) {
                Provider.of<WishListProvider>(context, listen: false)
                    .setIsChanged();
              }
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/home/1.png')),
                  label: "Offers".tr()),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/home/2.png')),
                  label: "Search".tr()),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined), label: "Cart".tr()),
              BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      Icon(Icons.favorite_border),
                      CircleAvatar(
                        backgroundColor: Colors.lightBlueAccent,
                        radius:
                            Provider.of<WishListProvider>(context).isChanged ==
                                    1
                                ? 5
                                : 0,
                      )
                    ],
                  ),
                  label: "Favorites"),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/home/5.png')),
                  label: "Profile".tr()),
            ],
          ),
        )));
  }
}
