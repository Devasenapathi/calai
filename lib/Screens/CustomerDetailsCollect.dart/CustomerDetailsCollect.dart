import 'dart:async';

import 'package:calai/utils/Color_resources.dart';
import 'package:calai/utils/ratings.dart';
import 'package:flutter/material.dart';

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
  String gender = "";
  String workouts = "";
  String otherApps = "";
  String diet = "";
  String accomplish = "";

  List<String> texts = [
    "Customizing health plan...",
    "Finalizing results...",
    "Estimating your metabolic age..."
  ];

  List<String> values = [
    "Calories",
    "Crabs",
    "Protiens",
    "Fats"
  ];
  int currentTextIndex = 0;

  int feet = 3;
  int inches = 1;
  int weight = 50;

  int day = 1;
  int month = 1;
  int year = 1;

  bool isMetric = false;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 17, vsync: this);
    _tabController.addListener(_updateProgress);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Container(
                  decoration: const BoxDecoration(
                      color: GREY1,
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: IconButton(
                    onPressed: () {
                      _updateBackProgress();
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: size.width * 0.9,
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
                _buildTabContent("Step 1", "This is the first step."),
                _buildTabContent("Step 2", "This is the second step."),
                _buildTabContent("Step 3", "This is the third step."),
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
        children: [
          const Text(
            "Choose Your Gender",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const Text("This will be used to callibrate your custom plan"),
          const Spacer(),
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: gender == "Male" ? WHITE : BLACK,
                  backgroundColor: gender == "Male" ? BLACK : GREY2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: Size(size.width * 1, 50),
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
                  minimumSize: Size(size.width * 1, 50),
                  textStyle: const TextStyle(fontSize: 18.0),
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
                  minimumSize: Size(size.width * 1, 50),
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
              if (gender.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select your gender")),
                );
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
                  minimumSize: Size(size.width * 1, 70),
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
                  minimumSize: Size(size.width * 1, 70),
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
                  minimumSize: Size(size.width * 1, 70),
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
              backgroundColor: BLACK,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, 50),
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
                  minimumSize: Size(size.width * 1, 70),
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
                  minimumSize: Size(size.width * 1, 70),
                  textStyle: const TextStyle(fontSize: 18.0),
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
              backgroundColor: BLACK,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, 50),
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
                width: 350,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const Text("Imperial"),
                        Row(
                          children: [
                            isMetric
                                ? Row(
                                    children: [
                                      SizedBox(
                                        height: 100,
                                        width: 80,
                                        child: ListWheelScrollView.useDelegate(
                                          itemExtent: 50,
                                          diameterRatio: 1.5,
                                          childDelegate:
                                              ListWheelChildBuilderDelegate(
                                            builder: (context, index) {
                                              bool isSelected =
                                                  (index + 3) == feet;
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
                                                    style: const TextStyle(
                                                        fontSize: 16),
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
                                        height: 100,
                                        width: 80,
                                        // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                        child: ListWheelScrollView.useDelegate(
                                          itemExtent: 50,
                                          diameterRatio: 1.5,
                                          childDelegate:
                                              ListWheelChildBuilderDelegate(
                                            builder: (context, index) {
                                              bool isSelected =
                                                  index + 1 == inches;
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
                                                    style: const TextStyle(
                                                        fontSize: 16),
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
                                    height: 100,
                                    width: 80,
                                    // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                    child: ListWheelScrollView.useDelegate(
                                      itemExtent: 50,
                                      diameterRatio: 1.5,
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
                                                '${index + 1} cm',
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ),
                                          );
                                        },
                                        childCount: 300,
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
                    Column(
                      children: [
                        const Text("Metrics"),
                        isMetric
                            ? SizedBox(
                                height: 100,
                                width: 80,
                                child: ListWheelScrollView.useDelegate(
                                  itemExtent: 50,
                                  diameterRatio: 1.5,
                                  childDelegate: ListWheelChildBuilderDelegate(
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
                                height: 100,
                                width: 80,
                                child: ListWheelScrollView.useDelegate(
                                  itemExtent: 50,
                                  diameterRatio: 1.5,
                                  childDelegate: ListWheelChildBuilderDelegate(
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
                ),
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
              minimumSize: Size(size.width * 1, 50),
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
              minimumSize: Size(size.width * 1, 50),
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
                      itemExtent: 50,
                      diameterRatio: 1.5,
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
                      itemExtent: 50,
                      diameterRatio: 1.5,
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
                      itemExtent: 50,
                      diameterRatio: 1.5,
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          bool isSelected = (index + 1970) == year;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected ? GREY1 : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1970}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                        childCount: 150,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          year = index + 1970;
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
              minimumSize: Size(size.width * 1, 50),
            ),
            onPressed: () {
              if (month != null) {
                // Validate that day, month, and year are selected
                DateTime dob = DateTime(year, month, day);
                // Use the DOB for whatever logic is needed
                print("DOB selected: $dob");
                // Continue with other logic, for example, moving to the next tab
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select a valid date")),
                );
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
                  minimumSize: Size(size.width * 1, 70),
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
                  minimumSize: Size(size.width * 1, 70),
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
                    minimumSize: Size(size.width * 1, 70),
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
                    minimumSize: Size(size.width * 1, 70),
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
              backgroundColor: BLACK,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, 50),
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
                  minimumSize: Size(size.width * 1, 70),
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
                  minimumSize: Size(size.width * 1, 70),
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
                    minimumSize: Size(size.width * 1, 70),
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
                    minimumSize: Size(size.width * 1, 70),
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
              backgroundColor: BLACK,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              minimumSize: Size(size.width * 1, 50),
            ),
            onPressed: () {
              if (workouts.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                  print("Need to complete redirect to playstore");
                  StoreRedirect.redirect(androidAppId: "com.farm2bag");
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
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
                    size: size.height*0.05,
                    color: Colors.amber[300],
                  ),
                  Icon(
                    Icons.star,
                    size: size.height*0.05,
                    color: Colors.amber[300],
                  ),
                  Icon(
                    Icons.star,
                    size: size.height*0.05,
                    color: Colors.amber[300],
                  ),
                  Icon(
                    Icons.star,
                    size: size.height*0.05,
                    color: Colors.amber[300],
                  ),
                  Icon(
                    Icons.star,
                    size: size.height*0.05,
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
              minimumSize: Size(size.width * 1, 50),
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
              minimumSize: Size(size.width * 1, 50),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Reach your goals with notifications",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Container(
                height: size.height * 0.3,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                    color: GREY2,
                    border: Border.all(
                      color: GREY2,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Hello world"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {}, child: const Text("Don't allow")),
                        ElevatedButton(
                            onPressed: () {}, child: const Text("Allow"))
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
              if (workouts.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                  _startTimer();
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
                  backgroundColor: Colors.transparent,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  minimumSize: Size(size.width * 0.1, 50),
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
            // border: Border.all(
            //   color: Colors.grey, // Use a color directly for GREY1
            // ),
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
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "You can edit this any time",
                  style: TextStyle(fontSize: 12.0),
                ),
                const SizedBox(height: 15), // Add space between the text and grid
                // Grid View with cards
                Expanded(
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2, // 2 columns in the grid
                    mainAxisSpacing: 10, // Vertical spacing between cards
                    crossAxisSpacing: 10, // Horizontal spacing between cards
                    childAspectRatio: 1, // Aspect ratio of each card (width/height)
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
                              alignment: Alignment.center, // Center items inside Stack
                              children: [
                                // Circular Progress Bar
                                Positioned.fill(
                                  child: Center(
                                    child: SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: CircularProgressIndicator(
                                        value: 0.7, // Progress value
                                        strokeWidth: 5, // Thicker stroke
                                        backgroundColor: Colors.grey.shade300, // Background color
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          _getProgressColor(index), // Dynamic color
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Text above CircularProgressIndicator
                                Positioned(
                                  top: 5,
                                  child: Text(
                                    values[index], // Display values from list
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Centered Text (e.g., "1100")
                                const Positioned(
                                  top: 40, // Adjust positioning
                                  child: Text(
                                    "1100", // Placeholder value
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Positioned Editable Icon (Edit icon at bottom right)
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
                                      // Action on Edit Icon click
                                      print('Edit button clicked on Card $index');
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
          // const Spacer(),
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
              if (workouts.isNotEmpty) {
                if (_tabController.index < _tabController.length - 1) {
                  _tabController.animateTo(_tabController.index + 1);
                  _startTimer();
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
        return Colors.blue; // Blue color for first card
      case 1:
        return Colors.green; // Green color for second card
      case 2:
        return Colors.orange; // Orange color for third card
      case 3:
        return Colors.red; // Red color for fourth card
      default:
        return Colors.blue;
    }
  }
