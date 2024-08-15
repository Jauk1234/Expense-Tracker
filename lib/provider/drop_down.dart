import 'package:flutter/material.dart';
import 'package:tracker/models/expense.dart';

class DropDown extends ChangeNotifier {
  final _allCategory = [
    Category.Food,
    Category.Travel,
    Category.Fun,
    Category.Work,
    Category.Hobby,
    Category.Others
  ];
  List<Category> get allCategory => _allCategory;

  Category selectedCategory = Category.Food;

  void setCategoryValue(Category category) {
    selectedCategory = category;
    notifyListeners();
  }
}
