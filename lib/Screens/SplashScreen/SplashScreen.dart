import 'package:calai/Screens/Stepers/Stepers.dart';
import 'package:calai/utils/Color_resources.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: BLACK,
      body: StepersScreen(),
    );
  }

}