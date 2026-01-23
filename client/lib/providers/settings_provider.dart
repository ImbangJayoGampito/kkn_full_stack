import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class SettingsProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeData => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  FlutterSecureStorage storage = FlutterSecureStorage();

  SettingsProvider() {
    storage.read(key: 'darkMode').then((value) {
      _isDarkMode = value == 'true';
      notifyListeners();
    });
  }
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    storage.write(key: 'darkMode', value: _isDarkMode.toString());
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    storage.write(key: 'darkMode', value: _isDarkMode.toString());
    notifyListeners();
  }
}
