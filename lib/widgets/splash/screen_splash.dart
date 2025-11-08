import 'package:flutter/material.dart';
import 'package:petrosafe_app/pages/page_login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/images/logo_petrosafe.png',
                    width: 200,
                  ),
                ],
              ),
            ),
            // Logo bawah
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Image.asset(
                'lib/assets/images/logo_elnusa.png',
                width: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
