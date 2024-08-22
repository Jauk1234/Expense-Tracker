import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tracker/database/expense_database.dart';

// TODO: Follow naming conventions through project, either it's Page or Screen
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, expenseDatabase, child) {
        final monthlyTotals = expenseDatabase.monthlyExpenseTotals;

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monthly Expenses',
                style: GoogleFonts.bebasNeue(
                  fontSize: 32,
                  color: const Color.fromARGB(255, 205, 166, 166),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: 12, // For all 12 months
                  itemBuilder: (context, index) {
                    // TODO: Here +1, inside _monthName -1, can be avoided both.
                    final month = index + 1;
                    final total = monthlyTotals[month] ?? 0.0;
                    return ListTile(
                      title: Text(
                        _monthName(month),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      trailing: Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
