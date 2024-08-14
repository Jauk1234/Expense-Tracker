import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/database/expense_database.dart';
import 'package:tracker/models/expense.dart';
import 'package:tracker/provider/drop_down.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<DropDown>(
      builder: (context, dropDownProvider, child) => Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddExpenseDialog(context),
          child: const Icon(Icons.add),
        ),
        body: Center(
          child: Text('Dummy data inserted'),
        ),
      ),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Expense'),
        content: Consumer<DropDown>(
          builder: (context, dropDownProvider, child) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Name'),
                controller: nameController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Description'),
                controller: descController,
              ),
              TextField(
                decoration: const InputDecoration(hintText: 'Amount'),
                keyboardType: TextInputType.number,
                controller: amountController,
              ),
              DropdownButton<Category>(
                value: dropDownProvider.selectedCategory,
                onChanged: (Category? newValue) {
                  if (newValue != null) {
                    dropDownProvider.setCategoryValue(newValue);
                  }
                },
                items: dropDownProvider.allCategory
                    .map<DropdownMenuItem<Category>>(
                  (Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.toString().split('.').last),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_validateAndSaveExpense(context)) {
                Navigator.pop(context);
              }
            },
            child: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }

  bool _validateAndSaveExpense(BuildContext context) {
    final name = nameController.text;
    final description = descController.text;
    final amountString = amountController.text;

    if (name.isEmpty || amountString.isEmpty) {
      // Show error dialog or toast
      return false;
    }

    final amount = double.tryParse(amountString);
    if (amount == null) {
      // Show error dialog or toast
      return false;
    }

    final expense = Expense(
      id: 0,
      name: name,
      description: description,
      amount: amount,
      date: DateTime.now(),
      category: context.read<DropDown>().selectedCategory,
    );

    Provider.of<ExpenseDatabase>(context, listen: false)
        .createNewExpense(expense);
    return true;
  }
}
