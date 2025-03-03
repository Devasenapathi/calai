// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:calai/Screens/Dashboard/Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:calai/utils/Color_resources.dart';
import 'package:calai/utils/ratings.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDetailsCollectScreen extends StatefulWidget {
  const CustomerDetailsCollectScreen({super.key});

  @override
  State<CustomerDetailsCollectScreen> createState() =>
      _CustomerDetailsCollectScreenState();
}

class _CustomerDetailsCollectScreenState
    extends State<CustomerDetailsCollectScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late FirebaseFirestore db = FirebaseFirestore.instance;
  String gender = "";
  String workouts = "";
  String otherApps = "";
  String diet = "";
  String accomplish = "";
  String? token = "";
  String selectedGoal = "";
  String chooseWeight = "";
  String selectedOption = "";
  String selectedDiet = "";
  String selectedAccomplish = "";
  double _selectedWeight = 0.5;
  late double minWeight;
  late double maxWeight;

  List<String> texts = [
    "Customizing health plan...",
    "Finalizing results...",
    "Estimating your metabolic age..."
  ];

  Map<String, TimeOfDay?> selectedTimes = {
    "First Meal": null,
    "Second Meal": null,
    "Third Meal": null,
  };

  List<String> values = ["Calories", "Crabs", "Protiens", "Fats"];
  int currentTextIndex = 0;

  int feet = 5;
  int inches = 5;
  int cm = 100;
  int weight = 120;
  String height = "";

  int day = 10;
  int month = 5;
  int year = 30;

  bool isMetric = false;
  double progress = 0.0;
  var box;

  late int selectedHour;
  late int selectedMinute;
  late String selectedPeriod;

  final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 25, vsync: this);
    _tabController.addListener(_updateProgress);

    DateTime now = DateTime.now();

    // ✅ Initialize class variables correctly
    selectedHour =
        now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    selectedMinute = now.minute;
    selectedPeriod = now.hour >= 12 ? "PM" : "AM";
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');

      if (token == null) {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          print("Google Sign-In aborted by user");
          return null;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        prefs.setString('token', userCredential.credential!.accessToken!);

        final user = <String, dynamic>{
          "name": userCredential.user!.displayName,
          "email": userCredential.user!.email,
          "profilePhoto": userCredential.user!.photoURL,
          "accessToken": userCredential.credential!.accessToken,
          "token": userCredential.credential!.token,
          "gender": gender,
          "workouts": workouts,
          "otherApps": otherApps,
          "diet": diet,
          "height": height,
          "weight": weight,
          "measures": '',
          "dob": "$day/$month/$year",
          "accomplish": accomplish,
          "notification": false,
          "isDelete": false,
          "status": 1,
        };
        // Add a new document with a generated ID
        db.collection("users").add(user).then((DocumentReference doc) => {
              print(doc),
              print("11111111111111111111111"),
              prefs.setString('id', doc.id),
              print('DocumentSnapshot added with ID: ${doc.id}')
            });

        return userCredential;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const DashboardScreen()));
      }
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
    return null;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    setState(() {
      progress = (_tabController.index + 1) / _tabController.length;
    });
  }

  void _updateBackProgress() {
    if (_tabController.index > 0) {
      _tabController.animateTo(_tabController.index - 1);
      setState(() {
        progress = (_tabController.index - 1) / _tabController.length;
      });
    }
  }

  void _startTimer() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentTextIndex = (currentTextIndex + 1) % texts.length;
      });
    });

    Future.delayed(const Duration(seconds: 12), () {
      if (_tabController.index < _tabController.length - 1) {
        _tabController.animateTo(_tabController.index + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: GREY1,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Center(
                  // Ensures the IconButton is centered
                  child: IconButton(
                    onPressed: () {
                      _updateBackProgress();
                    },
                    icon: const Icon(Icons.arrow_back),
                    iconSize:
                        16, // Adjust size if needed to fit well in the container
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                child: SizedBox(
                  width: size.width * 0.8,
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5.0,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGenderTab(),
                _buildWorkoutTab(),
                _buildOtherappTab(),
                _buildGraphTab(),
                _buildHeightWeightTab(),
                _buildDOBTab(),
                _buildgoal(),
                _buildChooseWeight(),
                _buildWeightLosingorGaining(),
                _buildSpeedPerWeek(),
                _buildCalAiVsYourOwn(),
                _buildStoppingToReacheYourGoals(),
                _buildSpecificDiet(),
                // _buildDietTab(),
                _buildAccomplishTab(),
                _buildCrushYourGoal(),
                _buildTimeEveryDay(),
                _buildRatingTab(),
                _buildThanksTab(),
                _buildNotificationTab(),
                _buildSettingTab(),
                _buildLoginTab(),
                _buildCompletionTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose Your Gender",
            style: TextStyle(fontSize: 33.0, fontWeight: FontWeight.bold),
          ),
          const Text("This will be used to callibrate your custom plan"),
          const Spacer(),
          SizedBox(
            height: size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: gender == "Male" ? WHITE : BLACK,
                    backgroundColor: gender == "Male" ? BLACK : GREY2,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(size.width * 1, size.height * 0.08),
                  ),
                  onPressed: () {
                    setState(() {
                      gender = "Male";
                    });
                  },
                  child: const Text("Male"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: gender == "Female" ? WHITE : BLACK,
                    backgroundColor: gender == "Female" ? BLACK : GREY2,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(size.width * 1, size.height * 0.08),
                    // textStyle: const TextStyle(fontSize: 18.0),
                  ),
                  onPressed: () {
                    setState(() {
                      gender = "Female";
                    });
                  },
                  child: const Text("Female"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: gender == "Others" ? WHITE : BLACK,
                    backgroundColor: gender == "Others" ? BLACK : GREY2,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(size.width * 1, size.height * 0.08),
                  ),
                  onPressed: () {
                    setState(() {
                      gender = "Others";
                    });
                  },
                  child: const Text("Others"),
                ),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: WHITE,
              backgroundColor: gender.isEmpty ? GREY1 : BLACK,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, size.height * 0.08),
            ),
            onPressed: () async {
              if (gender.isNotEmpty) {
                // await manager.init();
                // updateData(gender,"gender");
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              }
            },
            child: const Text("Next Step"),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "How many workouts do you do per week?",
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "This will be used to calibrate your custom plan.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              _buildWorkoutOption(
                  "0-2", "Workouts now and then", Icons.circle_outlined),
              const SizedBox(height: 12),
              _buildWorkoutOption(
                  "3-5", "A few workouts per week", Icons.more_horiz),
              const SizedBox(height: 12),
              _buildWorkoutOption(
                  "6+", "Dedicated athlete", Icons.sports_gymnastics),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor:
                  workouts.isNotEmpty ? Colors.black : Colors.grey[300],
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              minimumSize: Size(size.width * 1, size.height * 0.07),
            ),
            onPressed: workouts.isNotEmpty
                ? () {
                    if (_tabController.index < _tabController.length - 1) {
                      _tabController.animateTo(_tabController.index + 1);
                    }
                  }
                : null,
            child: const Text("Next", style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutOption(String value, String subtitle, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          workouts = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: workouts == value ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: workouts == value ? Colors.white : Colors.black),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: workouts == value ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: workouts == value ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtherappTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Have you tried other calorie tracking apps?",
            style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Column(
            children: [
              _buildOptionButton("Yes", Icons.thumb_up, size),
              const SizedBox(height: 10),
              _buildOptionButton("No", Icons.thumb_down, size),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: WHITE,
              backgroundColor: otherApps.isNotEmpty ? BLACK : GREY1,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, size.height * 0.08),
            ),
            onPressed: () {
              if (otherApps.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              }
            },
            child: const Text("Next Step"),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String value, IconData icon, Size size) {
    bool isSelected = otherApps == value;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Colors.black : Colors.transparent,
        side: BorderSide(
          color: isSelected ? Colors.black : Colors.grey,
          width: 2.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: Size(size.width * 1, size.height * 0.08),
      ),
      onPressed: () {
        setState(() {
          otherApps = value;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(width: 20),
          Text(value.toUpperCase(),
              style:
                  TextStyle(color: isSelected ? Colors.white : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildHeightWeightTab() {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Height & Weight",
            style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
          ),
          const Text("This will be used to calibrate your custom plan"),
          const Spacer(),

          // Unit Switch (Metric ↔ Imperial)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Imperial", style: TextStyle(fontSize: 20.0)),
              Switch(
                activeColor: Colors.black,
                value: isMetric,
                onChanged: (bool newValue) {
                  setState(() {
                    isMetric = newValue;

                    if (isMetric) {
                      // Convert lbs to kg and feet/inches to cm
                      weight = (weight * 0.453592).round();
                      cm = ((feet * 30.48) + (inches * 2.54)).round();
                    } else {
                      // Convert kg to lbs and cm to feet/inches
                      weight = (weight * 2.20462).round();
                      double totalCm = cm.toDouble();
                      feet = (totalCm / 30.48).floor();
                      inches = ((totalCm / 2.54) % 12).round();
                    }
                  });
                },
              ),
              const Text("Metric", style: TextStyle(fontSize: 20.0)),
            ],
          ),

          const SizedBox(height: 20),

          // Height & Weight Pickers
          Row(
            children: [
              // Height Picker
              Column(
                children: [
                  Text("Height",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  isMetric
                      ? _buildHeightPickerMetric()
                      : _buildHeightPickerImperial(),
                ],
              ),
              const Spacer(),
              // Weight Picker
              Column(
                children: [
                  Text("Weight",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  isMetric
                      ? _buildWeightPickerMetric()
                      : _buildWeightPickerImperial(),
                ],
              ),
            ],
          ),

          const Spacer(),

          // Next Step Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, size.height * 0.08),
            ),
            onPressed: () {
              if (_tabController.index < _tabController.length - 1) {
                _tabController.animateTo(_tabController.index + 1);
              }
            },
            child: const Text("Next Step"),
          ),
        ],
      ),
    );
  }

// Metric Height Picker (cm)
  Widget _buildHeightPickerMetric() {
    return SizedBox(
      height: 200,
      width: 80,
      child: ListWheelScrollView.useDelegate(
        controller: FixedExtentScrollController(initialItem: cm - 100),
        itemExtent: 50,
        diameterRatio: 5,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            bool isSelected = (index + 100) == cm; // Check if selected
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected ? GREY1 : Colors.transparent, // Highlight
              ),
              child: Center(
                child: Text(
                  "${index + 100} cm",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            );
          },
          childCount: 120,
        ),
        onSelectedItemChanged: (index) {
          setState(() {
            cm = index + 100;
          });
        },
      ),
    );
  }

// Imperial Height Picker (Feet & Inches)
  Widget _buildHeightPickerImperial() {
    return Row(
      children: [
        // Feet
        SizedBox(
          height: 200,
          width: 80,
          child: ListWheelScrollView.useDelegate(
            controller: FixedExtentScrollController(initialItem: feet - 3),
            itemExtent: 50,
            diameterRatio: 5,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                bool isSelected = (index + 3) == feet; // Check if selected
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected ? GREY1 : Colors.transparent, // Highlight
                  ),
                  child: Center(
                    child: Text(
                      "${index + 3} ft",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
              childCount: 8,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                feet = index + 3;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        // Inches
        SizedBox(
          height: 200,
          width: 80,
          child: ListWheelScrollView.useDelegate(
            controller: FixedExtentScrollController(initialItem: inches),
            itemExtent: 50,
            diameterRatio: 5,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                bool isSelected = index == inches; // Check if selected
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected ? GREY1 : Colors.transparent, // Highlight
                  ),
                  child: Center(
                    child: Text(
                      "$index in",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                );
              },
              childCount: 12,
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                inches = index;
              });
            },
          ),
        ),
      ],
    );
  }

// Metric Weight Picker (kg)
  Widget _buildWeightPickerMetric() {
    return SizedBox(
      height: 200,
      width: 80,
      child: ListWheelScrollView.useDelegate(
        controller: FixedExtentScrollController(initialItem: weight - 40),
        itemExtent: 50,
        diameterRatio: 5,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            bool isSelected = (index + 40) == weight; // Check if selected
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected ? GREY1 : Colors.transparent, // Highlight
              ),
              child: Center(
                child: Text(
                  "${index + 40} kg",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            );
          },
          childCount: 110,
        ),
        onSelectedItemChanged: (index) {
          setState(() {
            weight = index + 40;
          });
        },
      ),
    );
  }

// Imperial Weight Picker (lbs)
  Widget _buildWeightPickerImperial() {
    return SizedBox(
      height: 200,
      width: 80,
      child: ListWheelScrollView.useDelegate(
        controller: FixedExtentScrollController(initialItem: weight - 90),
        itemExtent: 50,
        diameterRatio: 5,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            bool isSelected = (index + 90) == weight; // Check if selected
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected ? GREY1 : Colors.transparent, // Highlight
              ),
              child: Center(
                child: Text(
                  "${index + 90} lb",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            );
          },
          childCount: 240,
        ),
        onSelectedItemChanged: (index) {
          setState(() {
            weight = index + 90;
          });
        },
      ),
    );
  }

  Widget _buildGraphTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Title
          const Text(
            "Cal AI creates \nlong-term results",
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Subtitle
          const Text(
            "This will be used to calibrate your custom plan",
            style: TextStyle(fontSize: 16.0, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // "Your Weight" Title
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Your weight",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // **Graph Section - Full Width**
          SizedBox(
            height: 200,
            width: double.infinity,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false), // Remove grid lines
                titlesData: FlTitlesData(
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text('1M',
                                style: TextStyle(fontSize: 12));
                          case 3:
                            return const Text('3M',
                                style: TextStyle(fontSize: 12));
                          case 6:
                            return const Text('6M',
                                style: TextStyle(fontSize: 12));
                          default:
                            return const Text('');
                        }
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  // **Black Line - Cal AI**
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3.5),
                      const FlSpot(1, 3.2),
                      const FlSpot(2, 2.8),
                      const FlSpot(3, 2.5),
                      const FlSpot(4, 2.3),
                      const FlSpot(5, 2.0),
                      const FlSpot(6, 1.8),
                    ],
                    isCurved: true,
                    color: Colors.black,
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: false),
                  ),

                  // **Red Line - Traditional Diet**
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3.5),
                      const FlSpot(1, 3.4),
                      const FlSpot(2, 3.3),
                      const FlSpot(3, 3.5),
                      const FlSpot(4, 3.8),
                      const FlSpot(5, 4.0),
                      const FlSpot(6, 4.2),
                    ],
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),

          Spacer(),

          // **Weight Loss Success Text**
          const Text(
            "80% of Cal AI users maintain their weight loss even 6 months later",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 10),

          // **Next Step Button**
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: WHITE,
              backgroundColor: BLACK,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, size.height * 0.08),
            ),
            onPressed: () {
              if (workouts.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select any option")),
                );
              }
            },
            child: const Text("Next Step"),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDOBTab() {
    Size size = MediaQuery.of(context).size;
    List<String> monthNames = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "When were you \nborn?",
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),

          // Subtitle
          const Text(
            "This will be used to calibrate your custom plan.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),

          // DOB Selection - ListWheelScrollView
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildWheelSelector(
                itemCount: 12,
                initialItem: month - 1,
                itemBuilder: (index) => monthNames[index],
                onSelectedItemChanged: (index) {
                  setState(() {
                    month = index + 1;
                  });
                },
                width: 100,
              ),
              const SizedBox(width: 10),
              _buildWheelSelector(
                itemCount: 31,
                initialItem: day - 1,
                itemBuilder: (index) => (index + 1).toString(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    day = index + 1;
                  });
                },
                width: 80,
              ),
              const SizedBox(width: 10),
              _buildWheelSelector(
                itemCount: 25,
                initialItem: year - 2000,
                itemBuilder: (index) => (2000 + index).toString(),
                onSelectedItemChanged: (index) {
                  setState(() {
                    year = 2000 + index;
                  });
                },
                width: 100,
              ),
            ],
          ),
          Spacer(),

          // Next Button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                minimumSize: Size(size.width * 0.9, 55),
              ),
              onPressed: () {
                DateTime dob = DateTime(year, month, day);
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              },
              child: const Text("Next", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

// Reusable function for Wheel Selectors
  Widget _buildWheelSelector({
    required int itemCount,
    required int initialItem,
    required String Function(int) itemBuilder,
    required ValueChanged<int> onSelectedItemChanged,
    required double width,
  }) {
    return SizedBox(
      height: 200,
      width: width,
      child: ListWheelScrollView.useDelegate(
        controller: FixedExtentScrollController(initialItem: initialItem),
        itemExtent: 50,
        diameterRatio: 2,
        physics: FixedExtentScrollPhysics(),
        overAndUnderCenterOpacity: 0.3,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            bool isSelected = index == initialItem;
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected
                    ? Colors.black.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  itemBuilder(index),
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal),
                ),
              ),
            );
          },
          childCount: itemCount,
        ),
        onSelectedItemChanged: onSelectedItemChanged,
      ),
    );
  }

  Widget _buildgoal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "What is your goal?",
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "This helps us generate a plan for your calorie intake.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Spacer(),

          goalOption("Gain Weight"),
          goalOption("Maintain"),
          goalOption("Lose Weight"),

          const Spacer(),

          // Updated button to match _buildOtherappTab()
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, // Text color
              backgroundColor: selectedGoal.isNotEmpty
                  ? Colors.black
                  : Colors.grey, // Dynamic color
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: const Size(
                  double.infinity, 55), // Same as _buildOtherappTab()
            ),
            onPressed: selectedGoal.isNotEmpty
                ? () {
                    if (selectedGoal == "Maintain") {
                      _tabController.animateTo(_tabController.index + 3);
                    } else {
                      _tabController.animateTo(_tabController.index + 1);
                    }
                  }
                : null, // Disables button if no goal is selected
            child: const Text(
              "Next",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget goalOption(String text) {
    bool isSelected = selectedGoal == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoal = text;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChooseWeight() {
    minWeight = isMetric ? 40 : 90;
    maxWeight = isMetric ? 150 : 330;
    var measure = isMetric ? "Kg" : "Lb";

    int visibleMarkers = 29;
    double markerSpacing = 12.0;

    // Centering Offset Calculation
    double centerOffset = ((visibleMarkers ~/ 2) * markerSpacing).toDouble();

    ScrollController _scrollController = ScrollController(
      initialScrollOffset: (weight - minWeight) * markerSpacing - centerOffset,
    );

    _scrollController.addListener(() {
      setState(() {
        int newWeight = (minWeight +
                (_scrollController.offset + centerOffset) / markerSpacing)
            .round();
        chooseWeight =
            newWeight.clamp(minWeight.toInt(), maxWeight.toInt()).toString();
      });
    });

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Choose your desired weight?",
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),
          const Spacer(),

          Center(
            child: Text(
              "$selectedGoal $chooseWeight",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Display Selected Weight
          Center(
            child: Column(
              children: [
                Text(
                  "$weight $measure",
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.keyboard_arrow_down,
                    size: 30, color: Colors.black),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Scrollable Weight Picker
          Center(
            child: SizedBox(
              height: 80,
              width: visibleMarkers * markerSpacing,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Divider(thickness: 2, color: Colors.grey[300]),

                  // Scrollable Weight Values
                  SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        (maxWeight - minWeight).toInt() + 1,
                        (index) {
                          int displayWeight = (minWeight + index).toInt();
                          bool isSelected = displayWeight == weight;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: [
                                Container(
                                  width: 3,
                                  height: isSelected ? 30 : 15,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey[400],
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                if (index % 2 == 0) const SizedBox(height: 5),
                                if (index % 2 == 0)
                                  Text(
                                    "$displayWeight",
                                    style: TextStyle(
                                      fontSize: isSelected ? 18 : 14,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.grey[400],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Fixed Center Marker
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3,
                      height: 35,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Next Button
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                minimumSize: const Size(double.infinity, 55),
              ),
              onPressed: () {
                double scrollOffset = _scrollController.offset;

                scrollOffset = scrollOffset.clamp(
                  0,
                  (maxWeight - minWeight) * markerSpacing - centerOffset,
                );

                _scrollController.animateTo(
                  scrollOffset,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );

                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              },
              child: const Text("Next",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightLosingorGaining() {
    Size size = MediaQuery.of(context).size;
    var measure = isMetric ? "Kg" : "Lb";
    return SizedBox.expand(
      // Ensures the Column takes full height
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.25),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text: "$selectedGoal"), // Shows the selected goal
                      TextSpan(
                        text: " ",
                        style: TextStyle(color: Colors.orange),
                      ),
                      TextSpan(
                        text: selectedGoal == "Gain Weight"
                            ? "${(int.tryParse(chooseWeight.replaceAll(".0", "")) ?? weight) - weight} $measure"
                            : "${weight - (int.tryParse(chooseWeight.replaceAll(".0", "")) ?? weight)} ${measure}",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange, // Highlighting the difference
                        ),
                      ),
                      TextSpan(
                        text: " is a realistic target. It’s not hard at all!",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                // Subtitle
                Text(
                  "90% of users say that the change is obvious after using Cal AI and it is not easy to rebound.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Spacer(), // Pushes the button to the bottom

          // Next Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(double.infinity, 55),
              ),
              onPressed: () {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              },
              child: Text("Next", style: TextStyle(fontSize: 18)),
            ),
          ),

          SizedBox(height: 40), // Spacing from bottom
        ],
      ),
    );
  }

  Widget _buildSpeedPerWeek() {
    Size size = MediaQuery.of(context).size;
    var measure = isMetric ? "Kg" : "Lb";
    double minValue = isMetric ? 0.5 : 0.2;
    double maxValue = isMetric ? 1.5 : 3.0;
    int divisions = isMetric ? 10 : 14; // To maintain step increments
    String _getRecommendationText() {
      if (_selectedWeight <= (minValue + (maxValue - minValue) / 3)) {
        return "Slow Progress, Safe & Steady";
      } else if (_selectedWeight > (minValue + (maxValue - minValue) / 3) &&
          _selectedWeight < (maxValue - (maxValue - minValue) / 3)) {
        return "Recommended";
      } else {
        return "You may feel very tried and \ndevelop loos skin";
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(
            "How fast do you want to reach your goal?",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          const SizedBox(height: 25),
          Text(
            "$selectedGoal speed per week",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
          Text(
            "${_selectedWeight.toStringAsFixed(1)} $measure",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.slow_motion_video,
                size: 30,
                color: _selectedWeight <= (minValue + (maxValue - minValue) / 3)
                    ? Colors.red
                    : Colors.black54, // Highlight if in slow range
              ),
              Icon(
                Icons.directions_run,
                size: 30,
                color:
                    (_selectedWeight > (minValue + (maxValue - minValue) / 3) &&
                            _selectedWeight <
                                (maxValue - (maxValue - minValue) / 3))
                        ? Colors.red
                        : Colors.black54, // Highlight if in medium range
              ),
              Icon(
                Icons.speed,
                size: 30,
                color: _selectedWeight >= (maxValue - (maxValue - minValue) / 3)
                    ? Colors.red
                    : Colors.black54, // Highlight if in fast range
              ),
            ],
          ),
          Slider(
            value: _selectedWeight,
            min: minValue,
            max: maxValue,
            divisions: divisions,
            activeColor: Colors.black,
            inactiveColor: Colors.grey[300],
            label: "${_selectedWeight.toStringAsFixed(1)} $measure",
            onChanged: (double value) {
              setState(() {
                _selectedWeight = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$minValue $measure",
                  style: TextStyle(color: Colors.black54)),
              Text(
                "${_selectedWeight.toStringAsFixed(1)} $measure",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("$maxValue $measure",
                  style: TextStyle(color: Colors.black54)),
            ],
          ),
          Spacer(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                _getRecommendationText(), // Dynamic Text
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 55),
            ),
            onPressed: () {
              if (_tabController.index < _tabController.length - 1) {
                _tabController.animateTo(_tabController.index + 1);
              }
            },
            child: Text(
              "Next",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCalAiVsYourOwn() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            "Lose twice as much weight with Cal AI vs on your own",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 40),

          // Comparison Box
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200], // Light background
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Comparison Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end, // Align at bottom
                  children: [
                    // Without Cal AI
                    SizedBox(
                      width: 100, // Adjust width as needed
                      child: Card(
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Text(
                              "Without\nCal AI",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 90),
                            Container(
                              width: 100, // Increase width of inner container
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    "20%",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // With Cal AI
                    SizedBox(
                      width: 100,
                      child: Card(
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Text(
                              "With\nCal AI",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                // Base Container (same height as "Without Cal AI")
                                Container(
                                  width: 60,
                                  height: 140, // Set same height
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "2X",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 15),

                // Description (Now properly positioned below the Row)
                Text(
                  "Cal AI makes it easy and holds \nyou accountable.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 55),
            ),
            onPressed: () {
              if (_tabController.index < _tabController.length - 1) {
                _tabController.animateTo(_tabController.index + 1);
              }
            },
            child: Text(
              "Next",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _buildStoppingToReacheYourGoals() {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's stopping you from reaching your goals?",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.03),

          // Options List with selection
          Column(
            children: [
              _buildOptionCard(size, Icons.bar_chart, "Lack of consistency"),
              _buildOptionCard(
                  size, Icons.bar_chart, "Unhealthy eating habits"),
              _buildOptionCard(size, Icons.handshake, "Lack of support"),
              _buildOptionCard(size, Icons.calendar_today, "Busy schedule"),
              _buildOptionCard(size, Icons.local_fire_department,
                  "Lack of meal inspiration"),
            ],
          ),

          Spacer(),

          // Next Button (Enabled only when an option is selected)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedOption.isNotEmpty ? Colors.black : Colors.grey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 55),
            ),
            onPressed: selectedOption.isNotEmpty
                ? () {
                    if (_tabController.index < _tabController.length - 1) {
                      _tabController.animateTo(_tabController.index + 1);
                    }
                  }
                : null, // Disables button if no option is selected
            child: Text(
              "Next",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for option card with selection logic
  Widget _buildOptionCard(Size size, IconData icon, String text) {
    bool isSelected = selectedOption == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = text;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: size.width,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              // Circular icon container
              Container(
                width: 40, // Circle size
                height: 30, // Circle size
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle, // Makes it circular
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.black, // Inverted color
                  ),
                ),
              ),
              SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecificDiet() {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Do you follow a \nspecific diet",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.07),

          // Options List with selection
          Column(
            children: [
              _buildSpecifiDietCard(size, Icons.restaurant, "Classic"),
              _buildSpecifiDietCard(size, Icons.set_meal, "Pescatarian"),
              _buildSpecifiDietCard(size, Icons.eco, "Vegetarian"),
              _buildSpecifiDietCard(size, Icons.grass, "Vegan"),
            ],
          ),

          Spacer(),

          // Next Button (Enabled only when an option is selected)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedDiet.isNotEmpty ? Colors.black : Colors.grey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 55),
            ),
            onPressed: selectedDiet.isNotEmpty
                ? () {
                    if (_tabController.index < _tabController.length - 1) {
                      _tabController.animateTo(_tabController.index + 1);
                    }
                  }
                : null, // Disables button if no option is selected
            child: Text(
              "Next",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for option card with selection logic
  Widget _buildSpecifiDietCard(Size size, IconData icon, String text) {
    bool isSelected = selectedDiet == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDiet = text;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: size.width,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              // Circular icon container
              Container(
                width: 40, // Circle size
                height: 40, // Circle size
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle, // Makes it circular
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.black, // Inverted color
                  ),
                ),
              ),
              SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDietTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Do you follow a specific diet",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          // const Text("This will be used to callibrate your custom plan"),
          const Spacer(),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: diet == "Classic" ? WHITE : BLACK,
                  backgroundColor: diet == "Classic" ? BLACK : GREY2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(size.width * 1, size.height * 0.08),
                ),
                onPressed: () {
                  setState(() {
                    diet = "Classic";
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.food_bank),
                    Text("Classic"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: diet == "Pescataian" ? WHITE : BLACK,
                  backgroundColor: diet == "Pescataian" ? BLACK : GREY2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(size.width * 1, size.height * 0.08),
                ),
                onPressed: () {
                  setState(() {
                    diet = "Pescataian";
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.dining),
                    Text("Pescataian"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: diet == "Vegtarian" ? WHITE : BLACK,
                    backgroundColor: diet == "Vegtarian" ? BLACK : GREY2,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(size.width * 1, size.height * 0.08),
                  ),
                  onPressed: () {
                    setState(() {
                      diet = "Vegtarian";
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.apple),
                      Text("Vegtarian"),
                    ],
                  )),
              const SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: diet == "Vegan" ? WHITE : BLACK,
                    backgroundColor: diet == "Vegan" ? BLACK : GREY2,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(size.width * 1, size.height * 0.08),
                  ),
                  onPressed: () {
                    setState(() {
                      diet = "Vegan";
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.apple_sharp),
                      Text("Vegan"),
                    ],
                  )),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: WHITE,
              backgroundColor: diet.isNotEmpty ? BLACK : GREY1,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, size.height * 0.08),
            ),
            onPressed: () {
              if (diet.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              }
            },
            child: const Text("Next Step"),
          ),
        ],
      ),
    );
  }

  Widget _buildAccomplishTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "What would you like \nto accomplish?",
            style: TextStyle(
              fontSize: 34.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.07),
          Column(
            children: [
              _buildAccomplishCard(size, Icons.apple, "Eat and live healthier"),
              _buildAccomplishCard(
                  size, Icons.wb_sunny, "Boost my energy and mood"),
              _buildAccomplishCard(
                  size, Icons.fitness_center, "Stay motivated and consistent"),
              _buildAccomplishCard(
                  size, Icons.self_improvement, "Feel better about my body"),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedAccomplish.isNotEmpty ? Colors.black : Colors.grey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 55),
            ),
            onPressed: selectedAccomplish.isNotEmpty
                ? () {
                    if (_tabController.index < _tabController.length - 1) {
                      _tabController.animateTo(_tabController.index + 1);
                    }
                  }
                : null, // Disables button if no option is selected
            child: Text(
              "Next",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccomplishCard(Size size, IconData icon, String text) {
    bool isSelected = selectedAccomplish == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAccomplish = text;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          width: size.width,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              // Circular icon container
              Container(
                width: 40, // Circle size
                height: 40, // Circle size
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle, // Makes it circular
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.black, // Inverted color
                  ),
                ),
              ),
              SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCrushYourGoal() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "You have great \npotential to crush \nyour \ngoal",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // Graph Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your weight transition",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                AspectRatio(
                    aspectRatio: 1.8,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0:
                                    return Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text("3 Days"),
                                    );
                                  case 1:
                                    return Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text("7 Days"),
                                    );
                                  case 2:
                                    return Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text("30 Days"),
                                    );
                                  default:
                                    return SizedBox();
                                }
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            left: BorderSide(
                                color: Colors.black, width: 2), // Left border
                            bottom: BorderSide(
                                color: Colors.black, width: 2), // Bottom border
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 1.5),
                              FlSpot(1, 2.8),
                              FlSpot(2, 4.2),
                            ],
                            isCurved: false,
                            color: Colors.brown,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.brown.withOpacity(0.5),
                                  Colors.brown.withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          Spacer(),

          // Next Button
          ElevatedButton(
            onPressed: () {
              if (_tabController.index < _tabController.length - 1) {
                _tabController.animateTo(_tabController.index + 1);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedAccomplish.isNotEmpty ? Colors.black : Colors.grey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 55),
            ),
            child: Text(
              "Next",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTimeEveryDay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Bar

          Text(
            "Do you typically eat \nyour meals at the \nsame time everyday?",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),

          // Meal Options
          _buildMealOption("First Meal"),
          _buildMealOption("Second Meal"),
          _buildMealOption("Third Meal"),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              if (_tabController.index < _tabController.length - 1) {
                _tabController.animateTo(_tabController.index + 1);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  selectedAccomplish.isNotEmpty ? Colors.black : Colors.grey,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 55),
            ),
            child: Text(
              "Next",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMealOption(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.restaurant, color: Colors.orange, size: 30),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: () => _selectTime(context, title),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    selectedTimes[title] == null
                        ? "Add Time"
                        : MaterialLocalizations.of(context).formatTimeOfDay(
                            selectedTimes[title]!,
                            alwaysUse24HourFormat:false,
                          ),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    selectedTimes[title] == null ? Icons.add : Icons.edit,
                    size: 18,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, String title) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Set Time",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPicker(1, 12, selectedHour, (val) {
                        setStateModal(() => selectedHour = val);
                      }),
                      Text(":", style: TextStyle(fontSize: 24)),
                      _buildPicker(0, 59, selectedMinute, (val) {
                        setStateModal(() => selectedMinute = val);
                      }),
                      _buildPickers(["AM", "PM"], selectedPeriod, (val) {
                        setStateModal(() => selectedPeriod = val);
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildButton("Cancel", Colors.black, () {
                        Navigator.pop(context);
                      }),
                      _buildButton("Apply", Colors.black, () {
                        // Update selectedTimes in parent widget
                        setState(() {
                          selectedTimes[title] = TimeOfDay(
                            hour: selectedPeriod == "AM"
                                ? selectedHour
                                : selectedHour + 12,
                            minute: selectedMinute,
                          );
                        });

                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPicker(int min, int max, int selected, Function(int) onChange) {
    return Container(
      width: 50,
      height: 150,
      child: CupertinoPicker(
        scrollController:
            FixedExtentScrollController(initialItem: selected - min),
        itemExtent: 40,
        onSelectedItemChanged: (index) => onChange(index + min),
        children: List.generate(max - min + 1, (index) {
          return Center(
            child: Text(
              "${index + min}".padLeft(2, '0'),
              style: TextStyle(fontSize: 20),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPickers(
      List<String> options, String selected, Function(String) onChange) {
    return Container(
      width: 70,
      height: 150,
      child: CupertinoPicker(
        scrollController:
            FixedExtentScrollController(initialItem: options.indexOf(selected)),
        itemExtent: 40,
        onSelectedItemChanged: (index) => onChange(options[index]),
        children: options
            .map((e) => Center(child: Text(e, style: TextStyle(fontSize: 20))))
            .toList(),
      ),
    );
  }

  Widget _buildButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: color),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: color, fontSize: 16)),
    );
  }

  Widget _buildRatingTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Give us rating",
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
          Container(
            height: size.height * 0.1,
            width: size.width * 0.9,
            decoration: BoxDecoration(
                border: Border.all(
                  color: GREY1,
                ),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: size.height * 0.05,
                    color: Colors.amber[300],
                  ),
                  Icon(
                    Icons.star,
                    size: size.height * 0.05,
                    color: Colors.amber[300],
                  ),
                  Icon(
                    Icons.star,
                    size: size.height * 0.05,
                    color: Colors.amber[300],
                  ),
                  Icon(
                    Icons.star,
                    size: size.height * 0.05,
                    color: Colors.amber[300],
                  ),
                  Icon(
                    Icons.star,
                    size: size.height * 0.05,
                    color: Colors.amber[300],
                  )
                ],
              ),
            ),
          ),
          // const Spacer(),
          const SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cal AI was made for people like you",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const Text("1000+ calAI users"),
              Container(
                height: size.height * 0.15,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    color: GREY,
                    border: Border.all(
                      color: GREY1,
                    ),
                    borderRadius: BorderRadius.circular(20)),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: size.height * 0.15,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    color: GREY,
                    border: Border.all(
                      color: GREY1,
                    ),
                    borderRadius: BorderRadius.circular(20)),
              )
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: WHITE,
              backgroundColor: BLACK,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, size.height * 0.08),
            ),
            onPressed: () {
              if (workouts.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select any option")),
                );
              }
            },
            child: const Text("Next Step"),
          ),
        ],
      ),
    );
  }

  Widget _buildThanksTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Spacer(),
          const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Thank you for trusting us",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                    "we promise to always keep your personal information private and secure"),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: WHITE,
              backgroundColor: BLACK,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, size.height * 0.08),
            ),
            onPressed: () {
              if (workouts.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select any option")),
                );
              }
            },
            child: const Text("Create my plan"),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            clipBehavior: Clip.hardEdge,
            // height: size.height * 0.3,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: const Center(
                child: Image(image: AssetImage("assets/images/athelete.webp"))),
          ),
          // const Spacer(),
          const SizedBox(
            height: 25,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Reach your goals with notifications",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: size.height * 0.2,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    color: GREY2,
                    border: Border.all(
                      color: GREY2,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Cal AI would like send you Notification",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: BLACK,
                              backgroundColor: WHITE,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              minimumSize: Size(size.width * 0.44, 50),
                            ),
                            onPressed: () {
                              if (_tabController.index <
                                  _tabController.length - 1) {
                                _tabController
                                    .animateTo(_tabController.index + 1);
                                _startTimer();
                              }
                            },
                            child: const Text("Don't allow")),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: BLACK,
                              backgroundColor: WHITE,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              minimumSize: Size(size.width * 0.44, 50),
                            ),
                            onPressed: () {
                              if (_tabController.index <
                                  _tabController.length - 1) {
                                _tabController
                                    .animateTo(_tabController.index + 1);
                                _startTimer();
                              }
                            },
                            child: const Text("Allow"))
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                  "You can turn off any of the reminders at any time in the settings. We won't spam you")
            ],
          ),
          const Spacer(),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     foregroundColor: WHITE,
          //     backgroundColor: BLACK,
          //     elevation: 1,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(50.0),
          //     ),
          //     minimumSize: Size(size.width * 1, size.height * 0.08),
          //   ),
          //   onPressed: () {
          //     if (workouts.isNotEmpty) {
          //       if (_tabController.index < _tabController.length - 1) {
          //         _tabController.animateTo(_tabController.index + 1);
          //         _startTimer();
          //       }
          //     } else {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(content: Text("Please select any option")),
          //       );
          //     }
          //   },
          //   child: const Text("Next Step"),
          // ),
        ],
      ),
    );
  }

  Widget _buildSettingTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "We're setting everything up for you",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                  "we promise to always keep your personal information private and secure"),
              AnimatedSwitcher(
                duration: const Duration(seconds: 3),
                child: Text(
                  texts[currentTextIndex],
                  key: ValueKey<int>(currentTextIndex),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                strokeWidth: 2.0,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildLoginTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: BLACK,
                  backgroundColor: WHITE,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  minimumSize: Size(size.width * 0.5, 70),
                ),
                onPressed: () {
                  signInWithGoogle().then((onValue) {
                    if (_tabController.index < _tabController.length - 1) {
                      _tabController.animateTo(_tabController.index + 1);
                    }
                  }).catchError((onError) {
                    print(onError);
                    print("222222222222222222");
                  });
                  // if (workouts.isNotEmpty) {
                  //   if (_tabController.index < _tabController.length - 1) {
                  //     _tabController.animateTo(_tabController.index + 1);
                  //   }
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text("Please select any option")),
                  //   );
                  // }
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage("assets/images/google.png")),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Sign in with Google")
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: BLACK,
                  backgroundColor: WHITE,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  minimumSize: Size(size.width * 0.2, 50),
                ),
                onPressed: () {
                  if (workouts.isNotEmpty) {
                    if (_tabController.index < _tabController.length - 1) {
                      _tabController.animateTo(_tabController.index + 1);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please select any option")),
                    );
                  }
                },
                child: const Text("skip"),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCompletionTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Congratulations your custom plan is ready!",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You should maintain:",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "195lb",
            style: TextStyle(fontSize: 18.0),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: size.height * 0.5,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                color: GREY2,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daily Recommendation",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "You can edit this any time",
                      style: TextStyle(fontSize: 12.0),
                    ),
                    const SizedBox(
                        height: 15), // Add space between the text and grid
                    // Grid View with cards
                    Expanded(
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 2, // 2 columns in the grid
                        mainAxisSpacing: 10, // Vertical spacing between cards
                        crossAxisSpacing:
                            10, // Horizontal spacing between cards
                        childAspectRatio:
                            1, // Aspect ratio of each card (width/height)
                        children: List.generate(
                          4,
                          (index) {
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              height: 80,
                                              width: 80,
                                              child: CircularProgressIndicator(
                                                value: 0.7,
                                                strokeWidth: 4,
                                                backgroundColor:
                                                    Colors.grey.shade300,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  _getProgressColor(index),
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              '1100',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 1),
                                        child: Text(
                                          values[index],
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 1,
                                      right: 1,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.black,
                                          size: 24,
                                        ),
                                        onPressed: () {
                                          print(
                                              'Edit button clicked on Card $index');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: WHITE,
              backgroundColor: BLACK,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, 50),
            ),
            onPressed: () {
              // if (workouts.isNotEmpty) {
              //   if (_tabController.index < _tabController.length - 1) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashboardScreen()));
              //   }
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text("Please select any option")),
              //   );
              // }
            },
            child: const Text("Next Step"),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 100, color: Colors.blue),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_tabController.index < _tabController.length - 1) {
                _tabController.animateTo(_tabController.index + 1);
              }
            },
            child: const Text("Next Step"),
          ),
        ],
      ),
    );
  }
}

Color _getProgressColor(int index) {
  switch (index) {
    case 0:
      return Colors.blue;
    case 1:
      return Colors.green;
    case 2:
      return Colors.orange;
    case 3:
      return Colors.red;
    default:
      return Colors.blue;
  }
}
