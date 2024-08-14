import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracker/models/expense.dart';

class ExpenseDatabase extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  List<Expense> _allExpenses = [];

  //SETUP

  //getters
  List<Expense> get allExpense => _allExpenses;

//OPERATIONS
  //create - add new expense
  Future<void> createNewExpense(Expense newExpense) async {
    final expenseData = {
      'Name': newExpense.name,
      'Description': newExpense.description,
      'Amount': newExpense.amount,
      'date': newExpense.date.toIso8601String(),
      'cateogry': newExpense.category,
    };
    await supabase.from('Expense').insert(expenseData);
  }

  //read - expenses from db
  Future<void> readExpenses() async {
    //fetch all existing expenses

    //give to local expense list

    //update UI
  }

  //update - edit expense
  Future<void> updateExpense(String expenseId, String updatedExpense) async {
    await supabase
        .from('Expense')
        .update({'name': updatedExpense}).eq('id', expenseId);
  }

  //delete
  Future<void> deleteExpense(String expenseId) async {
    await supabase.from('Expense').delete().eq('id', expenseId);
  }
}
