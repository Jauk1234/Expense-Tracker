import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tracker/components/bar_graph_data.dart';
import 'package:tracker/components/individual_bar.dart';

class MyBarGraph extends StatelessWidget {
  const MyBarGraph({
    super.key,
    required this.weeklySummary,
  });

  final List<double> weeklySummary;

  @override
  Widget build(BuildContext context) {
    // Assuming the categories are always in the same order
    // TODO: Refactor flow for BarData, overkill, reconsider BarData object.
    final BarData myBarData = BarData(
      workAmount: weeklySummary[0],
      travelAmount: weeklySummary[1],
      funAmount: weeklySummary[2],
      foodAmount: weeklySummary[3],
      hobbyAmount: weeklySummary[4],
      othersAmount: weeklySummary[5],
    );
    myBarData.initializeBarData();

    double maxY = weeklySummary.reduce((a, b) => a > b ? a : b);

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
        barGroups: myBarData.barData
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
                      toY: maxY + 10, // Ensure background rod covers the maxY
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

Widget getLeftTitles(double value, TitleMeta meta) {
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      value.toString(),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}
