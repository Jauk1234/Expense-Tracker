import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracker/main.dart';
import 'package:tracker/pages/home_page.dart';

class AuthProvider extends ChangeNotifier {
  final supabase = Supabase.instance.client;

  bool _isLogin = true;

  bool get isLogin => _isLogin;

  void toggleForm() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Up Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // TODO: App does not support persistent login

  Future<void> signUp(
      {required String email,
      required String password,
      required String username,
      BuildContext? context}) async {
    try {
      await supabase.auth.signUp(
        password: password.trim(),
        email: email.trim(),
        data: {'username': username.trim()},
      );
      {
        if (context != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    } on AuthException catch (e) {
      if (context != null) {
        _showErrorDialog(context, e.message);
      } else {
        print(e.message);
      }
    }
  }

  Future<void> signIn(
      {required String email,
      required String password,
      BuildContext? context}) async {
    try {
      await supabase.auth.signInWithPassword(
        password: password.trim(),
        email: email.trim(),
      );

      {
        if (context != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
      }
    } on AuthException catch (e) {
      if (context != null) {
        _showErrorDialog(context, e.message);
      } else {
        print(e.message);
      }
    }
  }
}
