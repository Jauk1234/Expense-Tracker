import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracker/models/expense.dart';
import 'package:uuid/uuid.dart';

class ExpenseDatabase extends ChangeNotifier {
  final supabase = Supabase.instance.client;
  DateTime? _pickedDate;
  DateTime? get pickedDate => _pickedDate;
  DateTime initialDate = DateTime.now();
  DateTime firstDate = DateTime(2024);
  DateTime lastDate = DateTime.now();
  final Uuid uuid = Uuid();
  int idExp = 1;

  povecaj() {
    return idExp = idExp + 1;
  }

  void pickDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ).then((value) {
      if (value != null) {
        _pickedDate = value;
        notifyListeners();
      }
    });
  }

  List<Expense> _allExpenses = [];

  //SETUP

  //getters
  List<Expense> get allExpense => _allExpenses;

//OPERATIONS
  //create - add new expense
  Future<void> createNewExpense(Expense newExpense) async {
    final expenseData = {
      'id': newExpense.id,
      'Name': newExpense.name,
      'Description': newExpense.description,
      'Amount': newExpense.amount,
      'date': newExpense.date.toIso8601String(),
      'cateogry': newExpense.category.toString().split('.').last,
    };

    _allExpenses.add(newExpense);
    notifyListeners();

    final response = await supabase.from('tracker').insert(expenseData);
  }

  //update - edit expense
  Future<void> updateExpense(String expenseId, Expense updateExpense) async {
    await supabase.from('tracker').update({
      'id': updateExpense.id,
      'Name': updateExpense.name,
      'Description': updateExpense.description,
      'Amount': updateExpense.amount,
      'date': updateExpense.date.toIso8601String(),
      'cateogry': updateExpense.category.toString().split('.').last,
    }).eq('id', expenseId);

    _allExpenses.removeWhere((expense) => expense.id == expenseId);
    _allExpenses.add(updateExpense);
    notifyListeners();
  }

  //delete
  Future<void> deleteExpense(String expenseId) async {
    print('Attempting to delete expense with ID: $expenseId');
    await supabase.from('tracker').delete().eq('id', expenseId);

    _allExpenses.removeWhere((expense) => expense.id == expenseId);
    notifyListeners();
  }
//

  // calucate total expdense each month
  Future<Map<int, double>> calculateMonthlyTotal() async {
    //read expenses from database

    //create a map to  keep track of total expenses per month
    Map<int, double> monthlyTotals = {};

    for (var expense in _allExpenses) {
      int month = expense.date.month;
// ako nema mjeseca u map neka bude 0
      if (!monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = 0;
      }
      monthlyTotals[month] = monthlyTotals[month]! + expense.amount;
    }
    return monthlyTotals;
  }

  //get start motnh
  int getStartMonth() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().month;
    }
    //soritaj
    _allExpenses.sort((a, b) => a.date.compareTo(b.date));
    return _allExpenses.first.date.month;
  }

  //get start year
  int getStartYear() {
    if (_allExpenses.isEmpty) {
      return DateTime.now().year;
    }
    //soritaj
    _allExpenses.sort((a, b) => a.date.compareTo(b.date));
    return _allExpenses.first.date.year;
  } // New method to get total for the selected month

  Future<Map<int, double>> calculateYearlyTotals() async {
    Map<int, double> monthlyTotals = {};

    // Iterate through expenses and calculate totals
    for (var expense in _allExpenses) {
      int month = expense.date.month;
      if (!monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = 0;
      }
      monthlyTotals[month] = monthlyTotals[month]! + expense.amount;
    }

    // Ensure all months are included
    for (int month = 1; month <= 12; month++) {
      if (!monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = 0;
      }
    }

    return monthlyTotals;
  }

  Future<Map<int, double>> calculateMonthlyTotalForSelectedMonth(
      DateTime selectedMonth) async {
    Map<int, double> monthlyTotals = {};

    // Iterate through expenses and calculate totals
    for (var expense in _allExpenses) {
      if (expense.date.year == selectedMonth.year &&
          expense.date.month == selectedMonth.month) {
        int month = expense.date.month;
        if (!monthlyTotals.containsKey(month)) {
          monthlyTotals[month] = 0;
        }
        monthlyTotals[month] = monthlyTotals[month]! + expense.amount;
      }
    }

    // Ensure all months are included
    for (int month = 1; month <= 12; month++) {
      if (!monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = 0;
      }
    }

    return monthlyTotals;
  }
}
