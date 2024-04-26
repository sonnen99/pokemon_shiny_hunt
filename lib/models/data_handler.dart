import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DataHandler extends ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  DataHandler({ThemeMode mode = ThemeMode.dark}) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
