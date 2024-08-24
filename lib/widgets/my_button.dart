import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.textColor,
    this.icon,
    required this.gradientColors, // New parameter for gradient colors
  });

  final String text;
  final void Function()? onTap;
  final Color textColor;
  final IconData? icon;
  final List<Color> gradientColors; // List of colors for the gradient

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(34),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: 22,
              ),
            ),
            if (icon != null) const SizedBox(width: 10),
            Icon(
              icon,
              color: textColor,
            ),
          ],
        ),
      ),
    );
  }
}
