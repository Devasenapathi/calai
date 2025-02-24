import 'dart:async';

import 'package:calai/Screens/Dashboard/Dashboard.dart';
import 'package:calai/Screens/Stepers/Stepers.dart';
import 'package:calai/Services/Services.dart';
import 'package:calai/utils/Color_resources.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late bool startScreen = false;
  late String? token = "";
  @override
  void initState() {
    super.initState(); 
    _hasToken();  
  }

  Future<void> _hasToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
     Timer(const Duration(seconds: 3), () {
      
        if (token != null) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const DashboardScreen()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const StepersScreen()));
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: BLACK,
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        decoration: const BoxDecoration(
          color: BLACK,
        ),
      ),
    );
  }
}
