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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

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
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                          height: screenHeight *
                              0.1), // Adjust height as a percentage of screen height
                      // Icon
                      const Icon(
                        Icons.account_circle_rounded,
                        size: 100,
                      ),
                      SizedBox(
                          height: screenHeight *
                              0.1), // Adjust height as a percentage of screen height
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
                      SizedBox(
                          height: screenHeight *
                              0.05), // Adjust height as a percentage of screen height
                      MyTextfield(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                      ),
                      SizedBox(
                          height: screenHeight *
                              0.02), // Adjust height as a percentage of screen height
                      MyTextfield(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                      ),
                      if (!isLogin) ...[
                        SizedBox(
                            height: screenHeight *
                                0.02), // Adjust height as a percentage of screen height
                        MyTextfield(
                          controller: usernameController,
                          hintText: 'Username',
                          obscureText: false,
                        ),
                      ],
                      SizedBox(
                          height: screenHeight *
                              0.05), // Adjust height as a percentage of screen height
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
                      SizedBox(
                          height: screenHeight *
                              0.1), // Adjust height as a percentage of screen height

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
                      SizedBox(
                          height: screenHeight *
                              0.1), // Adjust height as a percentage of screen height
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
