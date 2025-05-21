import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FA),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 48.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset('img/logo.png', fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Apprenez dès aujourd\'hui à\nGérer vos dépenses',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Avec notre nouvelle application de suivi de dépense, gardez la mains sur vos fonds et gérez les de la manière qui vous arrange',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 32),
                const CircularProgressIndicator(color: Color.fromARGB(255, 0, 101, 3)),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
