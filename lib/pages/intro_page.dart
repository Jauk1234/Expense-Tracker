import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/widgets/my_button.dart';

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
                image: AssetImage("lib/images/wall.jpg"),
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
                  Column(
                    children: [
                      SizedBox(height: 75),
                      Text(
                        'Simplify Spending, Maximize Savings!',
                        style: GoogleFonts.bebasNeue(
                          color: const Color.fromARGB(255, 255, 19, 19),
                          fontSize: 61,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Expense Tracer',
                        style: GoogleFonts.bebasNeue(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      Image.asset(
                        "lib/images/stocs.jpg",
                        height: 140,
                      ),
                    ],
                  ),
                  if (ind == 0)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyButton(
                          textColor: Colors.black,
                          onTap: idiDalje,
                          text: 'Let\'s Go!',
                          icon: Icons.arrow_right,
                          gradientColors: const [
                            Color.fromARGB(255, 245, 35, 35),
                            Color.fromARGB(255, 255, 3, 3)
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Effortlessly manage and monitor your spending with our Expense Tracker app. Track expenses, set budgets, and gain insights into your financial habits to stay on top of your personal finances.',
                          style: GoogleFonts.volkhov(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    )
                  else if (ind == 1)
                    Column(
                      children: [
                        MyButton(
                          textColor: Colors.black,
                          gradientColors: const [
                            Color.fromARGB(255, 245, 35, 35),
                            Color.fromARGB(255, 255, 3, 3)
                          ],
                          text: 'Continue with Email',
                          onTap: _submit,
                          icon: Icons.arrow_right,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Effortlessly manage and monitor your spending with our Expense Tracker app. Track expenses, set budgets, and gain insights into your financial habits to stay on top of your personal finances.',
                          style: GoogleFonts.volkhov(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (ind == 1)
            Positioned(
              right: 22,
              top: 40,
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: const CircleBorder(),
                onPressed: vratiNazad,
                child: Transform.rotate(
                  angle: 45 * 3.14 / 180,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
