import 'package:calai/utils/Color_resources.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GREY2,
        centerTitle: false,
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: size.width * 1,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              GREY2,
              WHITE,
            ],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Age"),
                  Spacer(),
                  Text(
                    "27",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text("Height"),
                  Spacer(),
                  Text("5 ft 10 in",
                      style: TextStyle(fontWeight: FontWeight.w700))
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text("Current weight"),
                  Spacer(),
                  Text("89kg", style: TextStyle(fontWeight: FontWeight.w700))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                "Cuztomization",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Personal details"),
              SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Adjust goals"),
                  Text(
                    "calories, carbs, fats, and protien",
                    style: TextStyle(fontSize: 8),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                "Legal",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Terms and Conditions"),
              SizedBox(
                height: 10,
              ),
              Text("Privacy Policy"),
              SizedBox(
                height: 10,
              ),
              Text("Delete Account"),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Text(
                "VERSION 1.0.0",
                style: TextStyle(fontSize: 8),
              )
            ],
          ),
        ),
      ),
    );
  }
}
