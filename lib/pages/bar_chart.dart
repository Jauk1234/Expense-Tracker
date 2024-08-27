import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/models/expense.dart';
import 'package:tracker/widgets/my_bar_graph.dart';
import 'package:tracker/database/expense_database.dart';

class BarChartPage extends StatelessWidget {
  const BarChartPage({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
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
        child: Center(
          child: FutureBuilder<Map<String, double>>(
            future: Provider.of<ExpenseDatabase>(context, listen: false)
                .calculateCategoryTotals(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final totals = snapshot.data!;
                final weeklySummary = [
                  totals['Work'] ?? 0.0,
                  totals['Travel'] ?? 0.0,
                  totals['Fun'] ?? 0.0,
                  totals['Food'] ?? 0.0,
                  totals['Hobby'] ?? 0.0,
                  totals['Others'] ?? 0.0,
                ];
                return SizedBox(
                  height: 400,
                  child: MyBarGraph(
                    expenses: expenses,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
