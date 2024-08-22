import 'package:flutter/material.dart';
import 'package:tracker/models/expense.dart';

// TODO: Naming convention, if it's a provider use suffix Provider
class DropDown extends ChangeNotifier {
  // TODO: Category.values, is shorter
  final _allCategory = [Category.Food, Category.Travel, Category.Fun, Category.Work, Category.Hobby, Category.Others];
  List<Category> get allCategory => _allCategory;

  Category selectedCategory = Category.Food;

  void setCategoryValue(Category category) {
    selectedCategory = category;
    notifyListeners();
  }
}
