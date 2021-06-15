import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/providers/stores_provider.dart';
import 'package:spain_project/providers/user_provider.dart';
import 'package:spain_project/screens/storemanager/my_bills_screen.dart';
import 'package:spain_project/screens/storemanager/orders_screen.dart';
import 'package:spain_project/screens/storemanager/profile_options_screens/about_screen.dart';
import 'package:spain_project/screens/storemanager/profile_options_screens/faqs_screen.dart';
import 'package:spain_project/screens/storemanager/profile_options_screens/my_notificaitons_screen.dart';
import 'package:spain_project/screens/storemanager/profile_options_screens/my_promotions_screen.dart';
import 'package:spain_project/screens/storemanager/profile_options_screens/payment_method_screen.dart';
import 'package:spain_project/screens/storemanager/profile_options_screens/store_trash_screen.dart';
import 'package:spain_project/screens/storemanager/update_store_address.dart';
import 'package:spain_project/utils/utilities.dart';

class AccountScreenStore extends StatefulWidget {
  @override
  _AccountScreenStoreState createState() => _AccountScreenStoreState();
}

class _AccountScreenStoreState extends State<AccountScreenStore> {
  int totalUnReadNotifications = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotifications();
  }

  getNotifications() async {
    await EasyLoading.show(
        status: 'loading..', maskType: EasyLoadingMaskType.black);
    final response = await Utilities.getPostRequestData(
        url: "${Utilities.baseUrl}getUserUnreadNotifications.php",
        form: {
          "storeId":
              Provider.of<StoreProvider>(context, listen: false).store.storeId
        });
    setState(() {
      totalUnReadNotifications = response['unreadNotifications'];
    });

    Logger().i(response);
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RefreshIndicator(
          onRefresh: () async {
            getNotifications();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            Provider.of<UserProvider>(context).user.imgUrl,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          radius: 28,
                          backgroundImage: imageProvider,
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  Provider.of<UserProvider>(context).user.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // IconButton(icon: Icon(Icons.edit,color: Colors.lightBlueAccent,), onPressed: (){
                                //
                                // })
                              ],
                            ),
                            Text(
                              Provider.of<UserProvider>(context).user.email,
                              style: TextStyle(color: Colors.black54),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                // AccountItemWidget(
                //   icon: 'assets/account/1.png',
                //   title: "My products".tr(),
                //   onTap: () {},
                // ),
                AccountItemWidget(
                  icon: 'assets/account/order.png',
                  title: "Orders".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rotate,
                            child: OrdersScreen()));
                  },
                ),
                AccountItemWidget(
                  icon: 'assets/account/2.png',
                  title: "My bills".tr(),
                  onTap: () {
                    final storeId =
                        Provider.of<StoreProvider>(context, listen: false)
                            .store
                            .storeId;
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: MyBillsScreen(
                              storeId: storeId,
                            )));
                  },
                ),
                AccountItemWidget(
                  icon: 'assets/account/3.png',
                  title: "Pick Up Address".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rotate,
                            child: UpdateStoreAddress()));
                  },
                ),
                AccountItemWidget(
                  icon: 'assets/account/4.png',
                  title: "Payment Method".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rotate,
                            child: PaymentMethodStoreScreen()));
                  },
                ),
                AccountItemWidget(
                  icon: 'assets/account/5.png',
                  title: "Promotions".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rotate,
                            child: MyPromotionsScreen()));
                  },
                ),
                Card(
                  child: ListTile(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rotate,
                              child: MyNotifcationsScreen(
                                id: Provider.of<StoreProvider>(context,
                                        listen: false)
                                    .store
                                    .storeId,
                                type: "store",
                              )));
                      setState(() {
                        totalUnReadNotifications = 0;
                      });
                    },
                    leading: ImageIcon(
                      AssetImage('assets/account/6.png'),
                      color: Colors.black,
                    ),
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Notifications".tr(),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.deepOrange,
                            child: Center(
                              child: Text(
                                "$totalUnReadNotifications",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
                AccountItemWidget(
                  icon: 'assets/account/7.png',
                  title: "FAQS".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rotate,
                            child: FaqsScreen()));
                  },
                ),
                AccountItemWidget(
                  icon: 'assets/account/1.png',
                  title: "Trash Bin".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rotate,
                            child: StoreTrashScreen()));
                  },
                ),
                AccountItemWidget(
                  icon: 'assets/account/8.png',
                  title: "About".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rotate,
                            child: AboutScreen()));
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                    child: ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.logout,
                    color: Colors.lightBlueAccent,
                    size: 30,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 60),
                    child: Text(
                      "Logout".tr(),
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountItemWidget extends StatelessWidget {
  final String icon;
  final String title;
  final Function onTap;
  final bool isLogout;
  AccountItemWidget({this.icon, this.title, this.onTap, this.isLogout = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: ImageIcon(
            AssetImage(icon),
            color: Colors.black,
          ),
          title: Text(
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
