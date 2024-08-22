import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tracker/database/expense_database.dart';
import 'package:tracker/pages/filters_page.dart';
import 'package:tracker/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tracker/pages/intro_page.dart';
import 'package:tracker/pages/login_or_register.dart';
import 'package:tracker/provider/auth_provider.dart';
import 'package:tracker/provider/drop_down.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Secrets, keys and similar are never "hardcoded" into the app.
  // TODO: Solution example: Consider using Dart environment variables
  await Supabase.initialize(
    url: 'https://xkkhspcxvztgpeebjvkk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inhra2hzcGN4dnp0Z3BlZWJqdmtrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM1NDgwNDksImV4cCI6MjAzOTEyNDA0OX0.ktnbpGeJCCKw0TMHv8gFohiOapAnqwWivg_FXy11fWw',
  );
  runApp(const MyApp());
}

// TODO: Not a good place for Supabase instance, lookup DependencyInjection
// TODO: In flutter global variables are only used if you are using Riverpod
// TODO: Solution Example: Consider passing the [Supabase.instance] to the [AuthProvider].
final supabase = Supabase.instance.client;

// TODO: Main should only contain app initialization configuration, extract MyApp to separate class
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
          create: (context) => DropDown(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // TODO: Resolve dart analysis in the entire project
        home: IntroPage(),
        // TODO: Route names are separated with "-" instead of "_"
        routes: {
          '/login_or_register': (context) => LoginOrRegister(),
          '/home_page': (context) => HomePage(),
          '/filters_page': (context) => FiltersPage(),
        },
      ),
    );
  }
}
