import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spain_project/providers/user_provider.dart';
import 'package:spain_project/utils/utilities.dart';

class CustomerMyProfile extends StatefulWidget {
  @override
  _CustomerMyProfileState createState() => _CustomerMyProfileState();
}

class _CustomerMyProfileState extends State<CustomerMyProfile> {
  String totalRatings = '';
  String totalOrders = '';
  String userAddress = '';
  String postalCode = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    EasyLoading.show(status: 'Loading...');
    final userEmail =
        Provider.of<UserProvider>(context, listen: false).user.email;
    final response = await Utilities.getPostRequestData(
        url: '${Utilities.baseUrl}userStates.php',
        form: {"userEmail": userEmail});
    Logger().i(response);
    setState(() {
      totalRatings = response['totalRatings'].toString();
      totalOrders = response['totalOrders'].toString();
      userAddress = response['userAddress'];
      postalCode = response['postalCode'].toString();
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "My Profile".tr(),
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: Provider.of<UserProvider>(context).user.imgUrl,
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 28,
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) => CircularProgressIndicator(),
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
                                fontWeight: FontWeight.bold, fontSize: 25),
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
            // Text(
            //   Provider.of<UserProvider>(
            //     context,
            //   ).user.name,
            //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            // Text(
            //   Provider.of<UserProvider>(
            //     context,
            //   ).user.email,
            //   style: TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.w500,
            //       color: Colors.black54),
            // ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(userAddress),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.post_add,
                  color: Colors.blue,
                  size: 30,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(postalCode),
                )
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Container(
                color: Colors.lightBlueAccent.withOpacity(.2),
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total Reviews".tr(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${totalRatings}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          )
                        ],
                      ),
                    )),
                    Expanded(
                        child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total Orders".tr(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${totalOrders}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54),
                          )
                        ],
                      ),
                    )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
