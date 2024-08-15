import 'package:flutter/material.dart';
import 'package:tracker/models/expense.dart';

class MyTile extends StatelessWidget {
  MyTile({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    String getImagePath(String category) {
      if (category == 'Work') {
        return 'lib/images/work.png';
      } else if (category == 'Travel') {
        return "lib/images/imagesTile/travel.jpg";
      } else if (category == 'Food') {
        return "lib/images/imagesTile/food.jpg";
      } else if (category == 'Others') {
        return "lib/images/imagesTile/others.jpg";
      } else if (category == 'Fun') {
        return "lib/images/imagesTile/fun.jpg";
      } else if (category == 'Hobby') {
        return "lib/images/imagesTile/hobi.webp";
      } else {
        return '';
      }
    }

    final imagePath = getImagePath(expense.category.toString().split('.').last);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      height: 270,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final imageHeight = constraints.maxHeight * 0.35;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Slika
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Image.asset(
                  imagePath,
                  height: imageHeight, // Use calculated height
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              // subtitle aktivnosti
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          expense.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[500],
                          ),
                        ),
                        Text(
                          expense.category.toString().split('.').last,
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 17),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            expense.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 17),
                            ),
                            Text(
                              '${expense.amount}\$',
                              style: TextStyle(
                                  color: Colors.grey[500], fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 20),
                            Icon(Icons.delete),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
