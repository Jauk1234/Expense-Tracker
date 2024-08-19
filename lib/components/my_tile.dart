import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/database/expense_database.dart';
import 'package:tracker/models/expense.dart';

class MyTile extends StatelessWidget {
  MyTile({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

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

    void _openDialog(Expense expense, BuildContext context) {
      String existingName = expense.name;
      String desc = expense.description;

      // showDialog(
      //   context: context,
      //   builder: (context) {
      //     return AlertDialog(
      //       title: Text('Edit expense'),
      //       content: Column(
      //         mainAxisSize: MainAxisSize.min,
      //         children: [
      //           TextField(
      //             controller: nameController,
      //             decoration: InputDecoration(hintText: existingName),
      //           ),
      //           TextField(
      //             controller: descController,
      //             decoration: InputDecoration(hintText: existingName),
      //           ),
      //           TextField(
      //             controller: amountController,
      //             decoration: InputDecoration(hintText: existingName),
      //           ),
      //         ],
      //       ),
      //       actions: [
      //         // Save button
      //         MaterialButton(
      //           onPressed: () async {
      //             if (nameController.text.isNotEmpty) {
      //               Navigator.pop(context);

      //               String updateExpense = expense.name;
      //               double updatedAmount = double.parse(amountController.text);

      //               int existingId = expense.id!;

      //               Expense updatedExpense = Expense(
      //                   name: updateExpense,
      //                   description: desc,
      //                   amount: 22,
      //                   date: DateTime.now(),
      //                   category: Category.Food);

      //               final expenseDatabase =
      //                   Provider.of<ExpenseDatabase>(context, listen: false);
      //               await expenseDatabase.updateExpense(
      //                   existingId, updatedExpense);
      //             }
      //           },
      //           child: Text('Save'),
      //         ),
      //       ],
      //     );
      //   },
      // );
    }

    final imagePath = getImagePath(expense.category.toString().split('.').last);

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
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
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
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 17),
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
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 17),
                            ),
                            Text(
                              '${expense.amount}\$',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 17),
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
                                  onPressed: () =>
                                      _openDialog(expense, context),
                                  icon: Icon(Icons.edit),
                                ),
                                SizedBox(width: 20),
                                IconButton(
                                  onPressed: () async {
                                    if (expense.id != null) {
                                      final expenseDatabase =
                                          Provider.of<ExpenseDatabase>(context,
                                              listen: false);
                                      await expenseDatabase
                                          .deleteExpense(expense.id!);
                                    } else {
                                      print('Expense id is null');
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
