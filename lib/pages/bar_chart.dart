import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/components/my_bar_graph.dart';
import 'package:tracker/database/expense_database.dart';

class BarChartPage extends StatefulWidget {
  const BarChartPage({super.key});

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {
  late Future<Map<String, double>> _categoryTotalsFuture;

  @override
  void initState() {
    super.initState();
    _categoryTotalsFuture = _fetchCategoryTotals();
  }

  Future<Map<String, double>> _fetchCategoryTotals() async {
    final expenseDatabase =
        Provider.of<ExpenseDatabase>(context, listen: false);
    final totals = await expenseDatabase.calculateCategoryTotals();
    return totals;
  }

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
            future: _categoryTotalsFuture,
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
                  child: MyBarGraph(weeklySummary: weeklySummary),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
