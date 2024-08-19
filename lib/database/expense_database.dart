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
  DateTime firstDate = DateTime(2000);
  DateTime lastDate = DateTime(2025);
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

    final response = await supabase.from('Expense').insert(expenseData);
  }

  //update - edit expense
  Future<void> updateExpense(int expenseId, Expense updateExpense) async {
    await supabase.from('Expense').update({
      'Name': updateExpense.name,
      'Description': updateExpense.description,
      'Amount': updateExpense.amount,
    }).eq('id', expenseId);
  }

  //delete
  Future<void> deleteExpense(int expenseId) async {
    print('Delete Id ${expenseId}');
    await supabase.from('Expense').delete().eq('id', expenseId);

    _allExpenses.removeWhere((expense) => expense.id == expenseId);
    notifyListeners();
  }
}
