import 'package:flutter/material.dart';
import 'package:client/models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
  bool isLoggedIn() {
    return _user != null;
  }
}
