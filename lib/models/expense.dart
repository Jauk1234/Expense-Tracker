import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Expense {
  final String id;
  final String name;
  final String description;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.name,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();
}

enum Category { Work, Travel, Fun, Food, Hobby, Others }
