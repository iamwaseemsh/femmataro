import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  static Future getValue(String key, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == "bool") {
      final value = await prefs.getBool(key) ?? false;
      return value;
    } else {
      final value2 = await prefs.getString(key) ?? "";
      return value2;
    }
    return;
  }

  static Future setStringValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future removeValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  static Future setBoolValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value2 = await prefs.getString('user') ?? "";

    if (value2.isEmpty) {
      return "";
    } else {
      return jsonDecode(value2);
    }
  }

  static Future setListValue({String name, List values}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(name, values);
  }

  static Future getListValue({String name}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value3 = await prefs.getStringList(name) ?? [];

    return value3;
  }
}
