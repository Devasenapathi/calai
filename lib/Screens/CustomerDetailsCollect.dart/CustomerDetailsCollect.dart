// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:calai/Screens/Dashboard/Dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  List<String> texts = [
    "Customizing health plan...",
    "Finalizing results...",
    "Estimating your metabolic age..."
  ];

  List<String> values = ["Calories", "Crabs", "Protiens", "Fats"];
  int currentTextIndex = 0;

  int feet = 5;
  int inches = 5;
  int cm = 100;
  int weight = 50;
  String height = "";

  int day = 10;
  int month = 5;
  int year = 30;

  bool isMetric = false;
  double progress = 0.0;
  var box;

  final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 14, vsync: this);
    _tabController.addListener(_updateProgress);
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
                _buildHeightWeightTab(),
                _buildGraphTab(),
                _buildDOBTab(),
                _buildDietTab(),
                _buildAccomplishTab(),
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
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "How many workouts do you do per week",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const Text("This will be used to callibrate your custom plan"),
          const Spacer(),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: workouts == "0-2" ? WHITE : BLACK,
                  backgroundColor: workouts == "0-2" ? BLACK : GREY2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(size.width * 1, size.height * 0.08),
                ),
                onPressed: () {
                  setState(() {
                    workouts = "0-2";
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.center_focus_strong),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("0-2"), Text("Workouts now and then")],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: workouts == "3-5" ? WHITE : BLACK,
                  backgroundColor: workouts == "3-5" ? BLACK : GREY2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(size.width * 1, size.height * 0.08),
                ),
                onPressed: () {
                  setState(() {
                    workouts = "3-5";
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.fitness_center),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("3-5"),
                        Text("A few workouts for a week")
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: workouts == "6+" ? WHITE : BLACK,
                  backgroundColor: workouts == "6+" ? BLACK : GREY2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(size.width * 1, size.height * 0.08),
                ),
                onPressed: () {
                  setState(() {
                    workouts = "6+";
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.run_circle_outlined),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text("6+"), Text("Dedicated Athlete")],
                    )
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: WHITE,
              backgroundColor: workouts.isNotEmpty ? BLACK : GREY1,
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
              }
            },
            child: const Text("Next Step"),
          ),
        ],
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
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: otherApps == "Yes" ? WHITE : BLACK,
                  backgroundColor: otherApps == "Yes" ? BLACK : GREY2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(size.width * 1, size.height * 0.08),
                ),
                onPressed: () {
                  setState(() {
                    otherApps = "Yes";
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.thumb_up),
                    SizedBox(
                      width: 20,
                    ),
                    Text("YES")
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: otherApps == "No" ? WHITE : BLACK,
                  backgroundColor: otherApps == "No" ? BLACK : GREY2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(size.width * 1, size.height * 0.08),
                ),
                onPressed: () {
                  setState(() {
                    otherApps = "No";
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.thumb_down),
                    SizedBox(
                      width: 20,
                    ),
                    Text("NO")
                  ],
                ),
              ),
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

  Widget _buildHeightWeightTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Height & Weight",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const Text("This will be used to callibrate your custom plan"),
          const Spacer(),
          Column(
            children: [
              SizedBox(
                width: size.width * 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Column(
                        children: [
                          Text(
                            "Imperial",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Height",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const Spacer(),
                      Switch(
                        activeColor: BLACK,
                        value: isMetric,
                        onChanged: (bool newValue) {
                          setState(() {
                            isMetric = newValue;
                          });
                        },
                      ),
                      const Spacer(),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Metrics",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Weight",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      isMetric
                          ? Row(
                              children: [
                                SizedBox(
                                  height: 200,
                                  width: 80,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: FixedExtentScrollController(
                                        initialItem: feet - 3),
                                    itemExtent: 50,
                                    diameterRatio: 5,
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      builder: (context, index) {
                                        bool isSelected = (index + 3) == feet;
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: isSelected
                                                ? GREY1
                                                : Colors.transparent,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 3} ft',
                                              style:
                                                  const TextStyle(fontSize: 16),
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
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 200,
                                  width: 80,
                                  // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                  child: ListWheelScrollView.useDelegate(
                                    controller: FixedExtentScrollController(
                                        initialItem: inches - 1),
                                    itemExtent: 50,
                                    diameterRatio: 5,
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      builder: (context, index) {
                                        bool isSelected = index + 1 == inches;
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: isSelected
                                                ? GREY1
                                                : Colors.transparent,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1} in',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      },
                                      childCount: 12,
                                    ),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        inches = index + 1;
                                      });
                                    },
                                  ),
                                )
                              ],
                            )
                          : SizedBox(
                              height: 200,
                              width: 80,
                              // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                              child: ListWheelScrollView.useDelegate(
                                controller: FixedExtentScrollController(
                                    initialItem: cm - 1),
                                itemExtent: 50,
                                diameterRatio: 5,
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    bool isSelected = index + 1 == cm;
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: isSelected
                                            ? GREY1
                                            : Colors.transparent,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1} cm',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: 300,
                                ),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    cm = index + 1;
                                  });
                                },
                              ),
                            ),
                      const Spacer(),
                      Column(
                        children: [
                          !isMetric
                              ? SizedBox(
                                  height: 200,
                                  width: 80,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: FixedExtentScrollController(
                                        initialItem: weight - 1),
                                    itemExtent: 50,
                                    diameterRatio: 5,
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      builder: (context, index) {
                                        bool isSelected = (index + 1) == weight;
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: isSelected
                                                ? GREY1
                                                : Colors.transparent,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1} kg',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      },
                                      childCount: 200,
                                    ),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        weight = index + 1;
                                      });
                                    },
                                  ),
                                )
                              : SizedBox(
                                  height: 200,
                                  width: 80,
                                  child: ListWheelScrollView.useDelegate(
                                    controller: FixedExtentScrollController(
                                        initialItem: weight - 1),
                                    itemExtent: 50,
                                    diameterRatio: 5,
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                      builder: (context, index) {
                                        bool isSelected = (index + 1) == weight;
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: isSelected
                                                ? GREY1
                                                : Colors.transparent,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1} lb',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      },
                                      childCount: 200,
                                    ),
                                    onSelectedItemChanged: (index) {
                                      setState(() {
                                        weight = index + 1;
                                      });
                                    },
                                  ),
                                )
                        ],
                      )
                    ],
                  )
                ],
              ),
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
              if (otherApps.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select any one")),
                );
              }
            },
            child: const Text("Next Step"),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphTab() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Cal AI creates a long term results",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const Text("This will be used to callibrate your custom plan"),
          const Spacer(),
          const Column(
            children: [],
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "Please select your Date of Birth",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const Text("This will be used to personalize your plan"),
          const Spacer(),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Day Selection
                  SizedBox(
                    height: 200,
                    width: 80,
                    child: ListWheelScrollView.useDelegate(
                      controller:
                          FixedExtentScrollController(initialItem: day - 1),
                      itemExtent: 50,
                      diameterRatio: 5,
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          bool isSelected = (index + 1) == day;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? GREY1 : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                        childCount: 31,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          day = index + 1;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 200,
                    width: 120,
                    child: ListWheelScrollView.useDelegate(
                      controller:
                          FixedExtentScrollController(initialItem: month - 1),
                      itemExtent: 50,
                      diameterRatio: 5,
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          bool isSelected = (index + 1) == month;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? GREY1 : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                monthNames[index],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                        childCount: 12,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          month = index + 1;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 200,
                    width: 80,
                    child: ListWheelScrollView.useDelegate(
                      controller:
                          FixedExtentScrollController(initialItem: year - 1),
                      itemExtent: 50,
                      diameterRatio: 5,
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          bool isSelected = (index + 1) == year;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? GREY1 : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1960}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                        childCount: 150,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          year = index + 1;
                        });
                      },
                    ),
                  ),
                ],
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
              DateTime dob = DateTime(year, month, day);
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
            "What would you like to accomplish",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          // const Text("This will be used to callibrate your custom plan"),
          const Spacer(),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      accomplish == "Eat and live healthier" ? WHITE : BLACK,
                  backgroundColor:
                      accomplish == "Eat and live healthier" ? BLACK : GREY2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(size.width * 1, size.height * 0.08),
                ),
                onPressed: () {
                  setState(() {
                    accomplish = "Eat and live healthier";
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.food_bank),
                    Text("Eat and live healthier"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      accomplish == "Boost my energy and mood" ? WHITE : BLACK,
                  backgroundColor:
                      accomplish == "Boost my energy and mood" ? BLACK : GREY2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(size.width * 1, size.height * 0.08),
                ),
                onPressed: () {
                  setState(() {
                    accomplish = "Boost my energy and mood";
                  });
                },
                child: const Row(
                  children: [
                    Icon(Icons.dining),
                    Text("Boost my energy and mood"),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        accomplish == "Stay motivated and consistent"
                            ? WHITE
                            : BLACK,
                    backgroundColor:
                        accomplish == "Stay motivated and consistent"
                            ? BLACK
                            : GREY2,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(size.width * 1, size.height * 0.08),
                  ),
                  onPressed: () {
                    setState(() {
                      diet = "Stay motivated and consistent";
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.apple),
                      Text("Stay motivated and consistent"),
                    ],
                  )),
              const SizedBox(height: 10),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: accomplish == "Feel better about my body"
                        ? WHITE
                        : BLACK,
                    backgroundColor: accomplish == "Feel better about my body"
                        ? BLACK
                        : GREY2,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(size.width * 1, size.height * 0.08),
                  ),
                  onPressed: () {
                    setState(() {
                      accomplish = "Feel better about my body";
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.apple_sharp),
                      Text("Feel better about my body"),
                    ],
                  )),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: WHITE,
              backgroundColor: accomplish.isNotEmpty ? BLACK : GREY1,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, size.height * 0.08),
            ),
            onPressed: () {
              if (accomplish.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                  StoreRedirect.redirect(androidAppId: "com.farm2bag");
                }
              }
            },
            child: const Text("Next Step"),
          ),
        ],
      ),
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
                      builder: (BuildContext context) =>
                          const DashboardScreen()));
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
