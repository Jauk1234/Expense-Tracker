import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracker/components/my_button.dart';
import 'package:tracker/components/my_textfield.dart';
import 'package:tracker/main.dart';
import 'package:tracker/pages/home_page.dart';
import 'package:tracker/provider/auth_provider.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({
    super.key,
    required this.onTap,
  });

  final Function()? onTap;

  // text editing controllers
  final emailContoller = TextEditingController();

  final passwordController = TextEditingController();

  final usernameContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [Colors.grey.shade500, Colors.grey.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
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
                  'Let\s create an account for you!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),

                //usernname textfield
                const SizedBox(height: 25),
                MyTextfield(
                  controller: emailContoller,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  controller: usernameContoller,
                  hintText: 'Username',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 25),
                MyButton(
                  text: 'Sign Up',
                  onTap: () {
                    Provider.of<AuthProvider>(context, listen: false).signUp(
                        emailContoller: emailContoller,
                        passwordController: passwordController,
                        usernameContoller: usernameContoller,
                        context: context);
                  },
                  gradientColors: [Colors.black, Colors.black],
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
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: onTap,
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
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
