import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:tracker/database/expense_database.dart';
import 'package:tracker/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracker/pages/intro_page.dart';
import 'package:tracker/pages/login_or_register.dart';
import 'package:tracker/provider/auth_provider.dart';
import 'package:tracker/provider/drop_down.dart';
import 'package:tracker/provider/page_state_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExpenseDatabase(),
        ),
        ChangeNotifierProvider(
          create: (context) => DropDownProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageStateProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: _handleAuthState(), // Proveri stanje autentifikacije
        routes: {
          '/login-or-register': (context) => LoginOrRegisterPage(),
          '/home-page': (context) => HomePage(),
        },
      ),
    );
  }

  Widget _handleAuthState() {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;
    if (session != null) {
      return HomePage();
    } else {
      return IntroPage();
    }
  }
}
