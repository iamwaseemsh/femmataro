import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class Utilities {
  static String currentLangauge = '';
  static setLanguageCode(String code) {
    currentLangauge = code;
  }

  static String baseUrl = 'http://54.68.165.122/appFiles/';
  static String baseImgUrl = "";
  static showSnackBar(BuildContext context, String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: new Text(value),
      duration: Duration(milliseconds: 1500),
    ));
  }

  static bool isEmpty(String value) {
    if (value.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static bool isNull(value) {
    if (value == null) {
      return true;
    } else {
      return false;
    }
  }

  static showLoading() {
    EasyLoading.show(status: 'Loading...');
  }

  static dismissLoading() {
    EasyLoading.dismiss();
  }

  static getPostRequestData({Map form, String url}) async {
    form['language'] = Utilities.currentLangauge;
    Logger().i(form);
    final response = await http.post(Uri.parse(url), body: form);
    final result = jsonDecode(response.body);
    return result;
  }

  static getGetRequestData(String url) async {
    final response = await http.get(Uri.parse(url));
    final result = jsonDecode(response.body);
    return result;
  }
}
