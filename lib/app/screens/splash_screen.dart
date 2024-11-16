// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import '../../utils/constants/color_constants.dart';
import '../../utils/constants/size_constants.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/logo.png',
              height: Sizes.imageLg * 1.5,
              width: Sizes.imageLg * 1.5,
            ),
          ),
          const AnimatedOpacity(
            duration: Duration(milliseconds: 800),
            opacity: 1.0,
            child: Text(
              'Unleash Your Inner Weeb',
              style: TextStyle(
                fontSize: Sizes.lg,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
