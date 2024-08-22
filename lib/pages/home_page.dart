import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tracker/database/expense_database.dart';
import 'package:tracker/models/expense.dart';
import 'package:tracker/pages/bar_chart.dart';
import 'package:tracker/pages/info_screen.dart';
import 'package:tracker/provider/drop_down.dart';
import 'package:tracker/components/my_tile.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  int _currentIndex = 0;
  Future<Map<int, double>>? _monthlyTotalsFuture;

  @override
  void initState() {
    super.initState();
    refreshGraphData();
    Provider.of<ExpenseDatabase>(context, listen: false)
        .addToFilteredExpenses([]);
  }

  void refreshGraphData() {
    _monthlyTotalsFuture = Provider.of<ExpenseDatabase>(context, listen: false)
        .calculateYearlyTotals();
  }

  final List<String> kategorije = [
    'Work',
    'Travel',
    'Fun',
    'Food',
    'Hobby',
    'Others'
  ];
  List<String> selektovaneKategorije = [];

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    switch (_currentIndex) {
      case 0:
        bodyContent = ExpensesContent(
          showAddExpenseDialog: _showAddExpenseDialog,
          nameController: nameController,
          descController: descController,
          amountController: amountController,
          kategorije: kategorije,
          selektovaneKategorije: selektovaneKategorije,
        );
        break;
      case 1:
        bodyContent = const InfoScreen();
        break;
      case 2:
        bodyContent = const BarChartPage();
        break;
      default:
        bodyContent = ExpensesContent(
          showAddExpenseDialog: _showAddExpenseDialog,
          nameController: nameController,
          descController: descController,
          amountController: amountController,
          kategorije: kategorije,
          selektovaneKategorije: selektovaneKategorije,
        );
    }

    return Scaffold(
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showAddExpenseDialog(context,
                  Provider.of<ExpenseDatabase>(context, listen: false)),
              child: const Icon(Icons.add),
            )
          : null,
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
        child: bodyContent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Chart',
          ),
        ],
      ),
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

  void _showAddExpenseDialog(BuildContext context, ExpenseDatabase expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Expense'),
        content: Consumer<DropDown>(
          builder: (context, dropDownProvider, child) => ExpenseForm(
            nameController: nameController,
            descController: descController,
            amountController: amountController,
            dropDownProvider: dropDownProvider,
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
            child: const Text('Cancel'),
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
}

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
                                    // Notify the ExpenseDatabase to update the filtered expenses
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
                          return MyTile(expense: expense);
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

class ExpenseForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descController;
  final TextEditingController amountController;
  final DropDown dropDownProvider;

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
        Consumer<ExpenseDatabase>(
          builder: (context, expenseDatabase, child) {
            return Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<ExpenseDatabase>().pickDate(context);
                  },
                  icon: const Icon(Icons.calendar_month),
                ),
                Text(
                  expenseDatabase.pickedDate != null
                      ? expenseDatabase.pickedDate.toString().split(' ')[0]
                      : 'No date picked',
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
