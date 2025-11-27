// lib/main.dart

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'registration_page.dart';
import 'screening_page.dart';
import 'diagnosis_page.dart';
import 'followup_page.dart';

void main() {
  runApp(const TBScreeningApp());
}

class TBScreeningApp extends StatelessWidget {
  const TBScreeningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TB-Connect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 100, 150),
          foregroundColor: Colors.white,
        ),
      ),
      // Define the application's routes
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegistrationPage(),
        '/screening': (context) => const ScreeningPage(),
        '/diagnosis': (context) => const DiagnosisPage(),
        '/followup': (context) => const FollowUpPage(),
      },
    );
  }
}
