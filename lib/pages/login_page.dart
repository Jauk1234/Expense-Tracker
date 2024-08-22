import 'package:flutter/material.dart';

import 'package:tracker/components/my_button.dart';
import 'package:tracker/components/my_textfield.dart';

// TODO: Implement [LoginPage] route
class LoginPage extends StatelessWidget {
  LoginPage({
    super.key,
    required this.onTap,
  });

  final Function()? onTap;

  // TODO: Controllers are initialized in "initState" method
  // TODO: Controllers need to be disposed in "dispose"
  // text editing controllers
  final emailContoller = TextEditingController();

  final passwordController = TextEditingController();

  //Login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 245, 212, 156),
              Color.fromARGB(255, 249, 190, 89),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 70),
                //icon
                const Icon(
                  Icons.account_circle_rounded,
                  size: 100,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Welcome!',
                  style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                ),

                //usernname textfield
                const SizedBox(height: 25),
                MyTextfield(
                  controller: emailContoller,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                const Spacer(),
                MyButton(
                  text: 'Sign in',
                  onTap: () {
                    Navigator.pushNamed(context, '/home_page');
                    // Provider.of<AuthProvider>(context, listen: false).signIn(
                    //   emailContoller: emailContoller,
                    //   passwordController: passwordController,
                    //   context: context,
                    // );
                  },
                  gradientColors: const [Colors.black, Colors.black],
                  textColor: Colors.white,
                ),
                const SizedBox(height: 15),
                const Divider(),

                //not a member?
                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
