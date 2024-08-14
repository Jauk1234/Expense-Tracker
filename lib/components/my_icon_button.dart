import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class MyIconButton extends StatelessWidget {
  const MyIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showPopover(
        context: context,
        bodyBuilder: (context) => Column(
          children: [
            Container(
              height: 50,
              color: Colors.deepPurple,
              child: Text('d'),
            ),
            Container(
              height: 50,
              color: Color.fromARGB(255, 112, 88, 154),
            ),
            Container(
              height: 50,
              color: const Color.fromARGB(255, 166, 157, 182),
            ),
          ],
        ),
        width: 250,
        height: 150,
      ),
      child: Icon(Icons.more_vert),
    );
  }
}
