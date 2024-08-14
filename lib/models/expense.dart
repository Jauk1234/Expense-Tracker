class Expense {
  final int? id;
  final String name;
  final String description;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
  });
}

enum Category { Work, Travel, Fun, Food, Hobby, Others }
