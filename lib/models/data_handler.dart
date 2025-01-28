import 'package:flutter/material.dart';

class DataHandler extends ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  DataHandler({ThemeMode mode = ThemeMode.dark}) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  int _sortValue = 0;

  void setSortValue(int value) {
    _sortValue = value;
    notifyListeners();
  }

  int get sortValue {
    return _sortValue;
  }

}
