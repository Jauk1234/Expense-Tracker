import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tracker/bar%20graph/bar_graph.dart';
import 'package:tracker/components/my_drawler.dart';
import 'package:tracker/components/my_tile.dart';
import 'package:tracker/database/expense_database.dart';
import 'package:tracker/models/expense.dart';
import 'package:tracker/provider/drop_down.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController descController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  void _showAddExpenseDialog(BuildContext context, ExpenseDatabase expense) {
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
                        expenseDatabase.pickedDate != null
                            ? expenseDatabase.pickedDate
                                .toString()
                                .split(' ')[0]
                            : 'No date picked',
                      ),
                    ],
                  );
                },
              ),
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

  Future<Map<int, double>>? _monthlyTotalsFuture;
  @override
  void initState() {
    super.initState();
    refreshGraphData(); // Initialize _monthlyTotalsFuture
  }

  void refreshGraphData() {
    _monthlyTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculateYearlyTotals();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, expenseDatabase, child) {
        int startMonth = expenseDatabase.getStartMonth();
        int starYear = expenseDatabase.getStartYear();
        int currentMonth = DateTime.now().month;
        int currentYear = DateTime.now().year;

        int calculateMounthCount(
            int startYeat, startMonth, currentYear, currentMonth) {
          int monthCount =
              (currentYear - starYear) * 12 + currentMonth - startMonth + 1;
          return monthCount;
        }

        int monthCount = calculateMounthCount(
            starYear, startMonth, currentYear, currentMonth);

        return Scaffold(
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
            onPressed: () => _showAddExpenseDialog(context, expenseDatabase),
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
                  ? Center(
                      child: Text(
                        'No expenses added yet.',
                        style: GoogleFonts.bebasNeue(
                          fontSize: 32,
                          color: const Color.fromARGB(255, 205, 166, 166),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : SafeArea(
                      child: Column(
                        children: [
                          // bar graph
                          SizedBox(
                            height: 250,
                            child: FutureBuilder(
                                future: _monthlyTotalsFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final monthlyTotals = snapshot.data ?? {};

                                    List<double> monthlySummary = List.generate(
                                      monthCount,
                                      (index) =>
                                          monthlyTotals[startMonth + index] ??
                                          0.0,
                                    );
                                    return MyBarGraph(
                                        monthlySummary: monthlySummary,
                                        startMonth: startMonth);
                                  } else {
                                    return const Center(
                                      child: Text('Loading...'),
                                    );
                                  }
                                }),
                          ),

                          Expanded(
                            child: ListView.builder(
                              itemCount: expenseDatabase.allExpense.length,
                              itemBuilder: (context, index) {
                                final expense =
                                    expenseDatabase.allExpense[index];
                                return MyTile(
                                  expense: expense,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
        );
      },
    );
  }

  bool _validateAndSaveExpense(BuildContext context) {
    refreshGraphData();
    final name = nameController.text;
    final description = descController.text;
    final amountString = amountController.text;

    if (name.isEmpty || amountString.isEmpty) {
      return false;
    }

    final amount = double.tryParse(amountString);
    if (amount == null) {
      return false;
    }

    final pickedDate = context.read<ExpenseDatabase>().pickedDate;

    final expenseDate = pickedDate ?? DateTime.now();

    final uzmiId = context.read<ExpenseDatabase>().povecaj();

    final expense = Expense(
      name: name,
      description: description,
      amount: amount,
      date: expenseDate,
      category: context.read<DropDown>().selectedCategory,
    );

    Provider.of<ExpenseDatabase>(context, listen: false)
        .createNewExpense(expense);
    refreshGraphData();
    return true;
  }
}
