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

// TODO: Not a good place for Supabase instance, lookup DependencyInjection
// TODO: In flutter global variables are only used if you are using Riverpod
// TODO: Solution Example: Consider passing the [Supabase.instance] to the [AuthProvider].
// final supabase = Supabase.instance.client;

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
          create: (context) => DropDownProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PageStateProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // TODO: Resolve dart analysis in the entire project
        home: IntroPage(),
        // TODO: Route names are separated with "-" instead of "_"
        routes: {
          '/login-or-register': (context) => LoginOrRegisterPage(),
          '/home-page': (context) => HomePage(),
        },
      ),
    );
  }
}
