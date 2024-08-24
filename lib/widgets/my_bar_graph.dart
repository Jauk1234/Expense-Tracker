import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tracker/models/expense.dart';
import 'package:tracker/widgets/individual_bar.dart';

class MyBarGraph extends StatelessWidget {
  const MyBarGraph({
    super.key,
    required this.expenses,
  });

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    // Agregirajte podatke po kategorijama
    final categoryTotals = <Category, double>{};
    for (var expense in expenses) {
      categoryTotals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    final barData = [
      IndividualBar(x: 0, y: categoryTotals[Category.Work] ?? 0),
      IndividualBar(x: 1, y: categoryTotals[Category.Travel] ?? 0),
      IndividualBar(x: 2, y: categoryTotals[Category.Fun] ?? 0),
      IndividualBar(x: 3, y: categoryTotals[Category.Food] ?? 0),
      IndividualBar(x: 4, y: categoryTotals[Category.Hobby] ?? 0),
      IndividualBar(x: 5, y: categoryTotals[Category.Others] ?? 0),
    ];

    double maxY = barData.fold(0, (max, data) => data.y > max ? data.y : max);

    return BarChart(
      BarChartData(
        maxY: maxY + 10,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barGroups: barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: Colors.grey[800],
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxY + 10,
                      color: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('Work', style: style);
      break;
    case 1:
      text = const Text('Travel', style: style);
      break;
    case 2:
      text = const Text('Fun', style: style);
      break;
    case 3:
      text = const Text('Food', style: style);
      break;
    case 4:
      text = const Text('Hobby', style: style);
      break;
    case 5:
      text = const Text('Others', style: style);
      break;
    default:
      text = const Text('');
      break;
  }
  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
