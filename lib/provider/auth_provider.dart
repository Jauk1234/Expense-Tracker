import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracker/main.dart';
import 'package:tracker/pages/home_page.dart';

// TODO: Supabase should be available within this class, not accessed through the global variable.
class AuthProvider extends ChangeNotifier {
  // TODO: App does not support persistent login

  // TODO: Never pass controllers, only pass values
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    } on AuthException catch (e) {
      // TODO: Implement error state handling on UI side
      print(e);
    }
  }

  // TODO: Never pass controllers, only pass values
  Future<void> signIn(
      {required TextEditingController emailContoller, required TextEditingController passwordController, BuildContext? context}) async {
    try {
      await supabase.auth.signInWithPassword(
        password: passwordController.text.trim(),
        email: emailContoller.text.trim(),
      );

      {
        if (context != null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    } on AuthException catch (e) {
      // TODO: Implement error state handling on UI side
      print(e);
    }
  }
}
