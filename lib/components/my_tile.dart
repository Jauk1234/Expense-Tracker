import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/database/expense_database.dart';
import 'package:tracker/models/expense.dart';
import 'package:tracker/provider/drop_down.dart';

// TODO: Do not use "My" prefix when working in production code :-)
class MyTile extends StatelessWidget {
  MyTile({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: expense.name);
    TextEditingController descController = TextEditingController(text: expense.description);
    TextEditingController amountController = TextEditingController(text: expense.amount.toString());

    // TODO: Images go to assets instead of lib/ directory
    String getImagePath(String category) {
      if (category == 'Work') {
        return 'lib/images/work.png';
      } else if (category == 'Travel') {
        return "lib/images/imagesTile/travel.jpg";
      } else if (category == 'Food') {
        return "lib/images/imagesTile/food.jpg";
      } else if (category == 'Others') {
        return "lib/images/imagesTile/others.jpg";
      } else if (category == 'Fun') {
        return "lib/images/imagesTile/fun.jpg";
      } else if (category == 'Hobby') {
        return "lib/images/imagesTile/hobi.webp";
      } else {
        return '';
      }
    }

    // TODO: Consider implementing and using a wrapper class for all dialog.
    // TODO: Consider what they all have in common.
    // TODO: Increase code reusability through entire project
    void _openDialog(Expense expense, BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit expense'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: 'Enter new name'),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(hintText: 'Enter new description'),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(hintText: 'Enter new amount'),
                ),
                Consumer<DropDown>(
                  builder: (context, value, child) {
                    return Row(
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
                          value: value.selectedCategory ?? expense.category,
                          onChanged: (Category? newValue) {
                            if (newValue != null) {
                              value.setCategoryValue(newValue);
                            }
                          },
                          items: value.allCategory.map<DropdownMenuItem<Category>>(
                            (Category category) {
                              return DropdownMenuItem<Category>(
                                value: category,
                                child: Text(category.toString().split('.').last),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    );
                  },
                ),
                Consumer<ExpenseDatabase>(
                  builder: (context, expenseDatabase, child) {
                    return Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            final calendar = context.read<ExpenseDatabase>();
                            calendar.pickDate(context);
                          },
                          icon: Icon(Icons.calendar_month),
                        ),
                        Text(
                          expenseDatabase.pickedDate != null ? expenseDatabase.pickedDate.toString().split(' ')[0] : 'No date picked',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // TODO: Check 3 main types of buttons used in Flutter, refactor
                  // TODO: https://docs.flutter.dev/release/breaking-changes/buttons
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      String updateName = nameController.text.isNotEmpty ? nameController.text : expense.name;
                      String updateDesc = descController.text.isNotEmpty ? descController.text : expense.description;
                      double updatedAmount = amountController.text.isNotEmpty ? double.parse(amountController.text) : expense.amount;
                      final selectedCategory = Provider.of<DropDown>(context, listen: false).selectedCategory ?? expense.category;
                      final selectedDate = Provider.of<ExpenseDatabase>(context, listen: false).pickedDate ?? expense.date;

                      Expense updatedExpense = Expense(
                        name: updateName,
                        description: updateDesc,
                        amount: updatedAmount,
                        date: selectedDate,
                        category: selectedCategory,
                      );

                      final expenseDatabase = Provider.of<ExpenseDatabase>(context, listen: false);
                      await expenseDatabase.updateExpense(expense.id, updatedExpense);

                      Navigator.pop(context);
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
              // Save button
            ],
          );
        },
      );
    }

    final imagePath = getImagePath(expense.category.toString().split('.').last);

    // TODO: Refactor
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      height: 270,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = constraints.maxHeight * 0.35;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                child: Image.asset(
                  imagePath,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          expense.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          expense.category.toString().split('.').last,
                          style: TextStyle(color: Colors.grey[500], fontSize: 17),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            expense.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              expense.date.toLocal().toString().split(' ')[0],
                              style: TextStyle(color: Colors.grey[600], fontSize: 17),
                            ),
                            Text(
                              '${expense.amount}\$',
                              style: TextStyle(color: Colors.grey[500], fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Consumer<ExpenseDatabase>(
                          builder: (context, expenseDatabase, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () => _openDialog(expense, context),
                                  icon: Icon(Icons.edit),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  onPressed: () async {
                                    if (expense.id.isNotEmpty) {
                                      final expenseDatabase = Provider.of<ExpenseDatabase>(context, listen: false);

                                      await expenseDatabase.deleteExpense(expense.id, expense, context);
                                    }
                                  },
                                  icon: Icon(Icons.delete),
                                )
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
