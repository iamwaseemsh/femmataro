import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/providers/bills_provider.dart';
import 'package:spain_project/providers/cart_provider.dart';
import 'package:spain_project/providers/customer_providers.dart';
import 'package:spain_project/providers/discount_providers.dart';
import 'package:spain_project/providers/product_provider.dart';
import 'package:spain_project/providers/store_orders_provider.dart';
import 'package:spain_project/providers/store_product_provider.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/providers/trash_provider.dart';
import 'package:spain_project/providers/user_provider.dart';
import 'package:spain_project/providers/wishlist_provider.dart';
import 'package:spain_project/utils/utilities.dart';

import 'screens/splash_screen.dart';

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  configLoading();
  runApp(EasyLocalization(
    supportedLocales: [Locale("en"), Locale("es"), Locale('ca')],
    path: "assets/translations",
    fallbackLocale: Locale('en'),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();
    Utilities.setLanguageCode(context.locale.languageCode);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => StoreProvider()),
        ChangeNotifierProvider(create: (ctx) => DiscountProvider()),
        ChangeNotifierProvider(create: (ctx) => StoreProvider()),
        ChangeNotifierProvider(create: (ctx) => StoreProductProvider()),
        ChangeNotifierProvider(create: (ctx) => StoreOrdersProvider()),
        ChangeNotifierProvider(create: (ctx) => TrashProvider()),
        ChangeNotifierProvider(create: (ctx) => CustomerOffersProvider()),
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
        ChangeNotifierProvider(create: (ctx) => WishListProvider()),
        ChangeNotifierProvider(create: (ctx) => BillsProvider()),
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
      ],
      child: MaterialApp(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        home: SplashScreen(),
        builder: EasyLoading.init(),
        theme: ThemeData(
            fontFamily: 'Montserrat',
            primaryTextTheme: TextTheme(
                title: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      ),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
