import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracker/main.dart';
import 'package:tracker/models/category.dart';
import 'package:tracker/models/expense.dart';

class ExpenseDatabase extends ChangeNotifier {
  //??????
  final supabase = Supabase.instance.client;
  //?????
  DateTime? _pickedDate;
  DateTime? get pickedDate => _pickedDate;
  DateTime initialDate = DateTime.now();
  DateTime firstDate = DateTime(2024);
  DateTime lastDate = DateTime.now();

  ExpenseDatabase() {
    // Initialize with empty filter
    addToFilteredExpenses([]);
  }
  String? getUserId() {
    final user = supabase.auth.currentUser;
    return user?.id;
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

  Future<void> loadExpenses() async {
    try {
      final userId = getUserId();
      if (userId == null) {
        // Handle case where user is not logged in or no user ID available
        _filteredExpenses.clear();
        notifyListeners();
        return;
      }

      final response =
          await supabase.from('tracker').select().eq('user_id', userId);

      _allExpenses = (response as List<dynamic>).map((item) {
        return Expense(
          name: item['Name'],
          description: item['Description'],
          amount: item['Amount'],
          date: DateTime.parse(item['date']),
          category: Category.values.firstWhere(
              (e) => e.toString().split('.').last == item['cateogry']),
          user_id: item['user_id'],
        );
      }).toList();

      addToFilteredExpenses([]);
      await calculateMonthlyTotals();
    } catch (e) {
      print('Error loading expenses: $e');
    }
  }

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
      'user_id': newExpense.user_id,
    };

    try {
      _allExpenses.add(newExpense);
      _updateMonthlyTotals(newExpense);
      notifyListeners();

      final response = await supabase.from('tracker').insert(expenseData);

      if (response == null || response.error != null) {
        print('Error inserting expense: ${response?.error?.message}');
        throw Exception('Failed to insert expense');
      }
    } catch (e) {
      print('Error creating new expense: $e');
    }
  }

  //update - edit expennnse
  Future<void> updateExpense(String expenseId, Expense updatedExpense) async {
    // Find the original expense before updating
    final originalExpense =
        _allExpenses.firstWhere((expense) => expense.id == expenseId);

    // Update the monthly totals by subtracting the original expense and adding the updated one
    _updateMonthlyTotals(originalExpense, isDeleting: true);
    _updateMonthlyTotals(updatedExpense);

    // Perform the update in the database
    await supabase.from('tracker').update({
      'id': updatedExpense.id,
      'Name': updatedExpense.name,
      'Description': updatedExpense.description,
      'Amount': updatedExpense.amount,
      'date': updatedExpense.date.toIso8601String(),
      'cateogry': updatedExpense.category.toString().split('.').last,
    }).eq('id', expenseId);

    // Update the expense list
    _allExpenses.removeWhere((expense) => expense.id == expenseId);
    _allExpenses.add(updatedExpense);
    notifyListeners();
  }

  //delete
  Future<void> deleteExpense(
      String expenseId, Expense expense, BuildContext context) async {
    final expenseIndex = _allExpenses.indexOf(expense);

    // Save the deleted expense before removing it
    final Expense deletedExpense = expense;

    // Update the monthly totals before deletion
    _updateMonthlyTotals(deletedExpense, isDeleting: true);

    // Perform the deletion from the database
    await supabase.from('tracker').delete().eq('id', expenseId);

    // Remove the expense from the list
    _allExpenses.removeWhere((expense) => expense.id == expenseId);

    // Show SnackBar with an Undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            // Add the expense back to the list and database
            _allExpenses.insert(expenseIndex, deletedExpense);
            _updateMonthlyTotals(deletedExpense); // Re-add the amount
            notifyListeners();

            // Re-insert the expense into the database
            final deletedExp = {
              'id': deletedExpense.id,
              'Name': deletedExpense.name,
              'Description': deletedExpense.description,
              'Amount': deletedExpense.amount,
              'date': deletedExpense.date.toIso8601String(),
              'cateogry': deletedExpense.category.toString().split('.').last,
            };

            await supabase.from('tracker').insert(deletedExp);
          },
        ),
      ),
    );

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

  // Method to calculate yearly totals (optional, if needed)
  Future<Map<int, double>> calculateYearlyTotals() async {
    Map<int, double> totals = {};
    for (var expense in _allExpenses) {
      int month = expense.date.month;
      double amount = expense.amount;

      if (totals.containsKey(month)) {
        totals[month] = totals[month]! + amount;
      } else {
        totals[month] = amount;
      }
    }
    _monthlyExpenseTotals = totals;
    notifyListeners();
    return totals;
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

  final List<Expense> _filteredExpenses = [];
  List<Expense> get filteredExpense => _filteredExpenses;

//dodaj expense u filt
  Future<void> addToFilteredExpenses(List<String> selectedCategories) async {
    final userId = getUserId();
    if (userId == null) {
      _filteredExpenses.clear();
      notifyListeners();
      return;
    }
    if (selectedCategories.isEmpty) {
      // If no categories are selected, show all expenses
      _filteredExpenses.clear();
      _filteredExpenses.addAll(_allExpenses);
    } else {
      // Filter expenses based on selected categories
      _filteredExpenses.clear();
      _filteredExpenses.addAll(_allExpenses.where((expense) {
        return selectedCategories
            .contains(expense.category.toString().split('.').last);
      }));
    }
    notifyListeners();
  }

  Future<void> refreshExpenses() async {
    await loadExpenses();
  }

  // Calculate total expense for each month
  Map<int, double> _monthlyExpenseTotals = {};
  Map<int, double> get monthlyExpenseTotals => _monthlyExpenseTotals;

  Future<void> calculateMonthlyTotals() async {
    Map<int, double> monthlyTotals = {};

    for (var expense in _allExpenses) {
      int month = expense.date.month;
      if (!monthlyTotals.containsKey(month)) {
        monthlyTotals[month] = 0;
      }
      monthlyTotals[month] = monthlyTotals[month]! + expense.amount;
    }

    _monthlyExpenseTotals = monthlyTotals;
    notifyListeners();
  }

  // Method to update monthly totals
  void _updateMonthlyTotals(Expense expense, {bool isDeleting = false}) {
    int month = expense.date.month;
    double amount = expense.amount;

    if (isDeleting) {
      // If deleting, subtract the amount from the total
      if (_monthlyExpenseTotals.containsKey(month)) {
        _monthlyExpenseTotals[month] = _monthlyExpenseTotals[month]! - amount;
        if (_monthlyExpenseTotals[month]! <= 0) {
          _monthlyExpenseTotals.remove(month); // Remove month if total is 0
        }
      }
    } else {
      // If adding, add the amount to the total
      if (_monthlyExpenseTotals.containsKey(month)) {
        _monthlyExpenseTotals[month] = _monthlyExpenseTotals[month]! + amount;
      } else {
        _monthlyExpenseTotals[month] = amount;
      }
    }

    notifyListeners();
  }

  // Method to calculate total expenses by category
  Future<Map<String, double>> calculateCategoryTotals() async {
    Map<String, double> categoryTotals = {};

    for (var expense in _allExpenses) {
      String category = expense.category.toString().split('.').last;
      if (categoryTotals.containsKey(category)) {
        categoryTotals[category] = categoryTotals[category]! + expense.amount;
      } else {
        categoryTotals[category] = expense.amount;
      }
    }
    return categoryTotals;
  }

  bool validateAndSaveExpense({
    required String name,
    required String description,
    required String amountString,
    DateTime? pickedDate,
    required Category selectedCategory,
  }) {
    if (name.isEmpty || amountString.isEmpty) {
      return false;
    }

    final amount = double.tryParse(amountString);
    if (amount == null) {
      return false;
    }

    final expenseDate = pickedDate ?? DateTime.now();

    // Retrieve the user_id from Supabase
    final user = supabase.auth.currentUser;
    final userId = user?.id; // Ensure user ID is not null

    // Create expense with user_id
    final expense = Expense(
      name: name,
      description: description,
      amount: amount,
      date: expenseDate,
      category: selectedCategory,
      user_id: userId, // Add user_id to the expense
    );

    createNewExpense(expense);
    return true;
  }
}
