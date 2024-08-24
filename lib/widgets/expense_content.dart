import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/database/expense_database.dart';
import 'package:tracker/widgets/my_tile.dart';

class ExpensesContent extends StatefulWidget {
  final Function showAddExpenseDialog;
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController amountController;
  final List<String> kategorije;
  final List<String> selektovaneKategorije;

  const ExpensesContent({
    Key? key,
    required this.showAddExpenseDialog,
    required this.nameController,
    required this.descController,
    required this.amountController,
    required this.kategorije,
    required this.selektovaneKategorije,
  }) : super(key: key);

  @override
  _ExpensesContentState createState() => _ExpensesContentState();
}

class _ExpensesContentState extends State<ExpensesContent> {
  late List<String> selektovaneKategorije;

  @override
  void initState() {
    super.initState();
    selektovaneKategorije = List.from(widget.selektovaneKategorije);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, expenseDatabase, child) {
        return expenseDatabase.allExpense.isEmpty
            ? Center(
                child: Text(
                  'No expenses added yet.',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilterChip(
                            selected: selektovaneKategorije.isEmpty,
                            label: const Text("All"),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selektovaneKategorije.clear();
                                }
                              });
                              Provider.of<ExpenseDatabase>(context,
                                      listen: false)
                                  .addToFilteredExpenses(selektovaneKategorije);
                            },
                          ),
                          ...widget.kategorije
                              .map(
                                (kategorija) => FilterChip(
                                  selected: selektovaneKategorije
                                      .contains(kategorija),
                                  label: Text(kategorija),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selektovaneKategorije.add(kategorija);
                                      } else {
                                        selektovaneKategorije
                                            .remove(kategorija);
                                      }
                                    });
                                    Provider.of<ExpenseDatabase>(context,
                                            listen: false)
                                        .addToFilteredExpenses(
                                            selektovaneKategorije);
                                  },
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: expenseDatabase.filteredExpense.length,
                        itemBuilder: (context, index) {
                          final expense =
                              expenseDatabase.filteredExpense[index];
                          return Tile(expense: expense);
                        },
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
