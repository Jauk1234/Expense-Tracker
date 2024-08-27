import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/widgets/my_button.dart';
import 'package:tracker/widgets/my_textfield.dart';
import 'package:tracker/provider/auth_provider.dart';

class LoginOrRegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authFormProvider, child) {
        final isLogin = authFormProvider.isLogin;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
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
                    // Icon
                    const Icon(
                      Icons.account_circle_rounded,
                      size: 100,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      isLogin
                          ? 'Welcome!'
                          : 'Let\'s create an account for you!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Conditional form based on isLogin state
                    const SizedBox(height: 25),
                    MyTextfield(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    MyTextfield(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                    ),
                    if (!isLogin) ...[
                      const SizedBox(height: 10),
                      MyTextfield(
                        controller: usernameController,
                        hintText: 'Username',
                        obscureText: false,
                      ),
                    ],
                    const SizedBox(height: 25),
                    MyButton(
                      text: isLogin ? 'Sign in' : 'Sign Up',
                      onTap: () {
                        if (isLogin) {
                          Provider.of<AuthProvider>(context, listen: false)
                              .signIn(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                          );
                        } else {
                          Provider.of<AuthProvider>(context, listen: false)
                              .signUp(
                            email: emailController.text,
                            password: passwordController.text,
                            username: usernameController.text,
                            context: context,
                          );
                        }
                      },
                      gradientColors: const [Colors.black, Colors.black],
                      textColor: Colors.white,
                    ),

                    const Spacer(),

                    // Toggle button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLogin
                              ? 'Not a member?'
                              : 'Already have an account?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => authFormProvider.toggleForm(),
                          child: Text(
                            isLogin ? 'Register now' : 'Login now',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
