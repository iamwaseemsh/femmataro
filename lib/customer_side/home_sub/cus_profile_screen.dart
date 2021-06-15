import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/customer_side/customer_orders_screen.dart';
import 'package:spain_project/providers/user_provider.dart';
import 'package:spain_project/screens/auth/social_signin_screen.dart';
import 'package:spain_project/screens/change_language_screen.dart';
import 'package:spain_project/screens/storemanager/account_screen_store.dart';
import 'package:spain_project/screens/storemanager/profile_options_screens/about_screen.dart';
import 'package:spain_project/screens/storemanager/profile_options_screens/faqs_screen.dart';
import 'package:spain_project/screens/storemanager/profile_options_screens/my_notificaitons_screen.dart';
import 'package:spain_project/screens/user_type_screen.dart';
import 'package:spain_project/utils/shared_pref_services.dart';
import 'package:spain_project/utils/utilities.dart';

import '../customer_my_profile_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
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
          "userEmail":
              Provider.of<UserProvider>(context, listen: false).user.email
        });
    setState(() {
      totalUnReadNotifications = response['unreadNotifications'];
    });

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
            child: Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              getNotifications();
            },
            child: ListView(
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
                AccountItemWidget(
                  icon: 'assets/account/1.png',
                  title: "Orders".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.topToBottom,
                            child: CustomerOrderScreen()));
                  },
                ),
                AccountItemWidget(
                  icon: 'assets/account/2.png',
                  title: "My Profile".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.topToBottom,
                            child: CustomerMyProfile()));
                  },
                ),
                // AccountItemWidget(
                //   icon: 'assets/account/3.png',
                //   title: "Location".tr(),
                //   onTap: () {
                //     final userEmail =
                //         Provider.of<UserProvider>(context, listen: false)
                //             .user
                //             .email;
                //     Logger().i(userEmail);
                //     Navigator.push(
                //         context,
                //         PageTransition(
                //             type: PageTransitionType.topToBottom,
                //             child: UpdateUserLocation(
                //               userEmail: userEmail,
                //             )));
                //   },
                // ),
                // AccountItemWidget(
                //   icon: 'assets/account/5.png',
                //   title: "Promo Code".tr(),
                //   onTap: () {},
                // ),
                Card(
                  child: ListTile(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rotate,
                              child: MyNotifcationsScreen(
                                id: Provider.of<UserProvider>(context,
                                        listen: false)
                                    .user
                                    .email,
                                type: "cus",
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
                  title: "Help".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rotate,
                            child: FaqsScreen()));
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
                AccountItemWidget(
                  icon: 'assets/account/8.png',
                  title: "Change Langauge".tr(),
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rotate,
                            child: ChangeLanguageScreen()));
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Card(
                    child: ListTile(
                  onTap: () async {
                    await SharedPrefServices.removeValue('user');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) => UserTypeScreen()),
                        (route) => false);

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctox) => SocialSignInScreen()));
                  },
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
        )));
  }
}
