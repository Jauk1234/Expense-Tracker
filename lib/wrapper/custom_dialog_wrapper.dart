import 'package:flutter/material.dart';

class CustomDialogWrapper extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  CustomDialogWrapper({
    required this.title,
    required this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content,
      actions: actions,
    );
  }
}
