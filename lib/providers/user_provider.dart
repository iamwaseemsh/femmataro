import 'package:flutter/material.dart';
import 'package:spain_project/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel user;
  signInUser(UserModel value) {
    user = value;
    notifyListeners();
  }

  logOutUser() {
    user = null;
    notifyListeners();
  }
}
