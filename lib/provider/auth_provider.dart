import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracker/main.dart';
import 'package:tracker/pages/home_page.dart';

class AuthProvider extends ChangeNotifier {
  Future<void> signUp(
      {required TextEditingController emailContoller,
      required TextEditingController passwordController,
      required TextEditingController usernameContoller,
      BuildContext? context}) async {
    try {
      await supabase.auth.signUp(
        password: passwordController.text.trim(),
        email: emailContoller.text.trim(),
        data: {'username': usernameContoller.text.trim()},
      );
      {
        if (context != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    } on AuthException catch (e) {
      print(e);
    }
  }

  Future<void> signIn(
      {required TextEditingController emailContoller,
      required TextEditingController passwordController,
      BuildContext? context}) async {
    try {
      await supabase.auth.signInWithPassword(
        password: passwordController.text.trim(),
        email: emailContoller.text.trim(),
      );

      {
        if (context != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    } on AuthException catch (e) {
      print(e);
    }
  }
}
