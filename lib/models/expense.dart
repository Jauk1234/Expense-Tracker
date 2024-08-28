import 'package:tracker/models/category.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Expense {
  final String id;
  final String name;
  final String description;
  final double amount;
  final DateTime date;
  final Category category;
  final String? user_id;

  //TODO: Generate toJson and fromJson using JsonSerializable package
  Expense({
    required this.name,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    this.user_id,
  }) : id = uuid.v4();
}
