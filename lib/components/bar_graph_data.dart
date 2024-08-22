import 'package:tracker/components/individual_bar.dart';

class BarData {
  final double workAmount;
  final double travelAmount;
  final double funAmount;
  final double foodAmount;
  final double hobbyAmount;
  final double othersAmount;

  BarData({
    required this.workAmount,
    required this.travelAmount,
    required this.funAmount,
    required this.foodAmount,
    required this.hobbyAmount,
    required this.othersAmount,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: workAmount),
      IndividualBar(x: 1, y: travelAmount),
      IndividualBar(x: 2, y: funAmount),
      IndividualBar(x: 3, y: foodAmount),
      IndividualBar(x: 4, y: hobbyAmount),
      IndividualBar(x: 5, y: othersAmount),
    ];
  }
}
