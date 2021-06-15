import 'package:shared_preferences/shared_preferences.dart';
import 'package:spain_project/utils/shared_pref_services.dart';

class StartingServices{
  static Future<bool> isWelcomeScreen()async{
    final value=await SharedPrefServices.getValue("isWelcomeScreen", "bool");

    return value;

  }



}