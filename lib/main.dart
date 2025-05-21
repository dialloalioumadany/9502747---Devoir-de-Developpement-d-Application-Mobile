import 'package:flutter/material.dart';
import 'package:todolist/dashboard.dart';
import 'package:todolist/login_page.dart';
import 'package:todolist/splash_screen.dart';
import 'package:todolist/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/dashboard': (context) => const DashboardPage(expenses: []),
      },
    );
  }
}
