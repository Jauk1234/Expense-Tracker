import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/database/expense_database.dart';
import 'package:tracker/models/expense.dart';
import 'package:tracker/pages/bar_chart.dart';
import 'package:tracker/pages/info_page.dart';
import 'package:tracker/provider/auth_provider.dart';
import 'package:tracker/provider/drop_down.dart';
import 'package:tracker/widgets/expense_content.dart';
import 'package:tracker/widgets/expense_form.dart';
import 'package:tracker/wrapper/custom_dialog_wrapper.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController nameController;
  late final TextEditingController descController;
  late final TextEditingController amountController;
  int _currentIndex = 0;
  Future<Map<int, double>>? _monthlyTotalsFuture;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descController = TextEditingController();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    amountController.dispose();
    super.dispose();
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
        bodyContent = const InfoPage();
        break;
      case 2:
        bodyContent = Consumer<ExpenseDatabase>(
          builder: (context, expenseDatabase, child) {
            return BarChartPage(expenses: expenseDatabase.allExpense);
          },
        );
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
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false)
                  .signOut(context);
            },
          ),
        ],
      ),
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

  void _showAddExpenseDialog(
      BuildContext context, ExpenseDatabase expenseDatabase) {
    showDialog(
      context: context,
      builder: (context) => CustomDialogWrapper(
        title: 'New Expense',
        content: Consumer<DropDownProvider>(
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
              final name = nameController.text;
              final description = descController.text;
              final amountString = amountController.text;
              final selectedCategory =
                  context.read<DropDownProvider>().selectedCategory;

              if (expenseDatabase.validateAndSaveExpense(
                name: name,
                description: description,
                amountString: amountString,
                pickedDate: context.read<ExpenseDatabase>().pickedDate,
                selectedCategory: selectedCategory,
              )) {
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
