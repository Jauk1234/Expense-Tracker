import 'package:flutter/material.dart';

class PageStateProvider extends ChangeNotifier {
  int _currentPageIndex = 0;

  int get currentPageIndex => _currentPageIndex;

  void goForward() {
    _currentPageIndex = 1;
    notifyListeners();
  }

  void goBack() {
    _currentPageIndex = 0;
    notifyListeners();
  }
}
