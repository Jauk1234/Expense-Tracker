import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/database/expense_database.dart';
import 'package:tracker/provider/drop_down.dart';
import 'package:tracker/models/category.dart';

class ExpenseForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController amountController;
  final DropDownProvider dropDownProvider;

  const ExpenseForm({
    Key? key,
    required this.nameController,
    required this.descController,
    required this.amountController,
    required this.dropDownProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
          decoration: const InputDecoration(hintText: 'Amount'),
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
              items:
                  dropDownProvider.allCategory.map<DropdownMenuItem<Category>>(
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
            IconButton(
              onPressed: () {
                context.read<ExpenseDatabase>().pickDate(context);
              },
              icon: const Icon(Icons.calendar_month),
            ),
            Text(
              context.watch<ExpenseDatabase>().pickedDate != null
                  ? context
                      .watch<ExpenseDatabase>()
                      .pickedDate
                      .toString()
                      .split(' ')[0]
                  : 'No date picked',
            ),
          ],
        ),
      ],
    );
  }
}
