import 'package:flutter/material.dart';
import 'package:tracker/components/my_button.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int ind = 0;
  void idiDalje() {
    setState(() {
      ind = 1;
    });
  }

  void vratiNazad() {
    setState(() {
      ind = 0;
    });
  }

  void _submit() {
    Navigator.pushNamed(context, '/login_or_register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/images/slika.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            // Center the whole Column within the Stack
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Column(
                    children: [
                      Icon(
                        Icons.border_color,
                        size: 90,
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Simplify Spending, Maximize Savings!',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 19, 19),
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Expense Tracer',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  if (ind == 0)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyButton(
                          textColor: Colors.black,
                          color: Colors.red,
                          onTap: idiDalje,
                          text: 'Let\s Go!',
                        ),
                        const SizedBox(height: 30),
                      ],
                    )
                  else if (ind == 1)
                    Column(
                      children: [
                        MyButton(
                          textColor: Colors.black,
                          color: Colors.red,
                          text: 'Continue with Email',
                          onTap: _submit,
                        ),
                        const SizedBox(height: 30),
                      ],
                    )
                ],
              ),
            ),
          ),
          if (ind == 1)
            Positioned(
              right: 22,
              top: 40,
              child: FloatingActionButton(
                onPressed: vratiNazad,
                child: Transform.rotate(
                  angle: 45 * 3.14 / 180,
                  child: const Icon(Icons.add),
                ),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: const CircleBorder(),
              ),
            ),
        ],
      ),
    );
  }
}
