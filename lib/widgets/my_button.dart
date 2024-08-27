import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.textColor,
    this.icon,
    required this.gradientColors,
  });

  final String text;
  final void Function()? onTap;
  final Color textColor;
  final IconData? icon;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(
          Colors.transparent,
        ),
        foregroundColor: WidgetStateProperty.all(textColor),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(34),
        ),
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 60,
            minWidth: double.infinity,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
              if (icon != null)
                Icon(
                  icon,
                  color: textColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
