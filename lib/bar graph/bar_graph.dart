import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tracker/bar%20graph/individual_bar.dart';

class MyBarGraph extends StatefulWidget {
  const MyBarGraph({
    super.key,
    required this.monthlySummary,
    required this.startMonth,
  });

  final List<double> monthlySummary;
  final int startMonth;

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  late List<IndividualBar> barData;

  @override
  void initState() {
    super.initState();
    initializeBarData();
  }

  void initializeBarData() {
    final totalMonths = 12; // Display all months of the year
    final startMonth = 1; // Start from January

    barData = List.generate(
      totalMonths,
      (index) {
        int monthIndex =
            (startMonth + index - 1) % 12 + 1; // Wrap around months
        double amount = widget.monthlySummary.isEmpty
            ? 0.0
            : (index < widget.monthlySummary.length)
                ? widget.monthlySummary[index]
                : 0.0;
        return IndividualBar(
          x: monthIndex - 1, // Month index for bar chart (0-based)
          y: amount,
        );
      },
    );
    print('Bar Data: $barData');
  }

  @override
  Widget build(BuildContext context) {
    double barWidth = 20;
    double spaceBetweenBars = 35; // Adjust spacing if needed

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width:
            barWidth * barData.length + spaceBetweenBars * (barData.length - 1),
        child: BarChart(
          BarChartData(
            minY: 0,
            maxY: barData.isNotEmpty
                ? barData.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.5
                : 100,
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(
              show: true,
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 50,
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
                        width: barWidth,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const textStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );

  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Jan';
      break;
    case 1:
      text = 'Feb';
      break;
    case 2:
      text = 'Mar';
      break;
    case 3:
      text = 'Apr';
      break;
    case 4:
      text = 'May';
      break;
    case 5:
      text = 'Jun';
      break;
    case 6:
      text = 'Jul';
      break;
    case 7:
      text = 'Aug';
      break;
    case 8:
      text = 'Sep';
      break;
    case 9:
      text = 'Oct';
      break;
    case 10:
      text = 'Nov';
      break;
    case 11:
      text = 'Dec';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      text,
      style: textStyle,
    ),
  );
}
