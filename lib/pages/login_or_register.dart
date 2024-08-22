import 'package:flutter/material.dart';
import 'package:tracker/pages/login_page.dart';
import 'package:tracker/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

// TODO: This is not needed. Refactor
// TODO: Login & Register are 2 different screens, if you want to update parts of the screen
// TODO: based on a button press that's used for different things not for entire pages.
class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showLoginPage = true;
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Why pass callback instead of using Provider?
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
