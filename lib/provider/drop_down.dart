import 'package:flutter/material.dart';
import 'package:tracker/models/category.dart';

class DropDownProvider extends ChangeNotifier {
  final _allCategory = Category.values;
  List<Category> get allCategory => _allCategory;

  Category selectedCategory = Category.Work;

  void setCategoryValue(Category category) {
    selectedCategory = category;
    notifyListeners();
  }
}
