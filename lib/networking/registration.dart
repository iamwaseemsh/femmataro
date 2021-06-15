import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:spain_project/models/category_model.dart';
import 'package:spain_project/utils/shared_pref_services.dart';
import 'package:spain_project/utils/utilities.dart';

final dio = Dio();
var logger = Logger();

class Registration {
  static Future<bool> checkIfUserExists(String email) async {
    final url = "${Utilities.baseUrl}checkEmail.php";

    final response =
        await http.post(Uri.parse(url), body: {"userEmail": email.trim()});
    final result = jsonDecode(response.body);
    print(result);
    return result['message'];
  }

  static Future<bool> checkIfStoreManagerExists(String email) async {
    final url = "${Utilities.baseUrl}checkStoreManager.php";
    final response =
        await http.post(Uri.parse(url), body: {"userEmail": email.trim()});
    final result = jsonDecode(response.body);
    print(result);
    return result['message'];
  }

  static Future registerUser(String phone, String name, String email) async {
    final url = "${Utilities.baseUrl}userRegisteration.php";

    // final res=await Dio().post(path)
    final response = await http.post(Uri.parse(url), body: {
      "userEmail": email.trim(),
      "userName": name.trim(),
      "userPhone": phone.trim()
    });
    final result = jsonDecode(response.body);
    return result['message'];
  }

  static Future StoreManagerRegisteration(
      String managerName, String cif, File file) async {
    final currentUser = await SharedPrefServices.getCurrentUser();

    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "cliImg": await MultipartFile.fromFile(file.path, filename: fileName),
      "storeManagerName": managerName.trim(),
      "cif": cif,
      "userEmail": currentUser['email'].trim(),
      "filename": fileName.trim()
    });
    final response = await Dio()
        .post("${Utilities.baseUrl}registerStoreManager.php", data: formData);
    return response.data;
  }

  static Future chechIfCifIsVerified() async {
    final currentUser = await SharedPrefServices.getCurrentUser();
    String url = "${Utilities.baseUrl}storeStatus.php";

    //using http
    final response = await http.post(Uri.parse(url), body: {
      "userEmail": currentUser['email'],
    });
    final result = jsonDecode(response.body);

    return result['message'];
  }

  static Future<List<CategoryModel>> getStoreCategories() async {
    String url = "${Utilities.baseUrl}storeCats.php";
    final res = await http.get(Uri.parse(url));
    final deCodedRes = jsonDecode(res.body);
    print(deCodedRes);
    final List<CategoryModel> temp = [];
    for (var item in deCodedRes['storeCats']) {
      temp.add(CategoryModel(
          catId: item['storeCatId'], catName: item['storeCatName']));
    }

    return temp;
  }

  static Future registerStore(
      {String catId,
      String storeName,
      String storeEmail,
      String address,
      String postalCode,
      String lati,
      String longi,
      File storeLogo,
      File storeImage}) async {
    final currentUser = await SharedPrefServices.getCurrentUser();
    String url = "${Utilities.baseUrl}storeData.php";

    String fileName = storeImage.path.split('/').last;
    String logoFileName = storeLogo.path.split('/').last;
    FormData formData = FormData.fromMap({
      "storeImg":
          await MultipartFile.fromFile(storeImage.path, filename: fileName),
      "userEmail": currentUser['email'],
      "storeName": storeName,
      "storeEmail": storeName,
      "logoImg":
          await MultipartFile.fromFile(storeLogo.path, filename: logoFileName),
      "storeAddress": address,
      "storeLati": lati,
      "storeLongi": longi,
      "postalCode": postalCode,
      "storeCatId": catId
    });

    final response =
        await Dio().post('${Utilities.baseUrl}storeData.php', data: formData);
    print(response.data);
    return jsonDecode(response.data);

    // final response = await http.post(Uri.parse(url), body: {
    //   "userEmail": currentUser['email'],
    //   "storeName": storeName,
    //   "storeEmail": storeName,
    //   "storeAddress": address,
    //   "storeLati": lati,
    //   "storeLongi": longi,
    //   "postalCode": postalCode,
    //   "storeCatId": catId
    // });
    // final result = jsonDecode(response.body);
    //   return result;
  }
}
