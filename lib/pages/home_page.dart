import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/components/my_drawler.dart';
import 'package:tracker/components/my_tile.dart';
import 'package:tracker/database/expense_database.dart';
import 'package:tracker/models/expense.dart';
import 'package:tracker/provider/drop_down.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

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
                maxLength: 25,
                controller: descController,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Amount',
                ),
                keyboardType: TextInputType.number,
                controller: amountController,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose category',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 18,
                    ),
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
              Row(
                children: [
                  Text('Pick a Date'),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              nameController.clear();
              amountController.clear();
              descController.clear();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_validateAndSaveExpense(context)) {
                Navigator.pop(context);
                nameController.clear();
                amountController.clear();
                descController.clear();
              }
            },
            child: const Text('Add Expense'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, expenseDatabase, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 245, 212, 156),
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          ),
        ),
        drawer: MyDrawler(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddExpenseDialog(context),
          child: const Icon(Icons.add),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 245, 212, 156),
                Color.fromARGB(255, 249, 190, 89),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: expenseDatabase.allExpense.isEmpty
              ? const Center(child: Text('No expenses added yet.'))
              : ListView.builder(
                  itemCount: expenseDatabase.allExpense.length,
                  itemBuilder: (context, index) {
                    final expense = expenseDatabase.allExpense[index];
                    return MyTile(
                      expense: expense,
                    );
                  },
                ),
        ),
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
