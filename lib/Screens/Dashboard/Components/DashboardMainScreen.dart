import 'package:calai/Screens/Dashboard/Components/StreakScreen.dart';
import 'package:calai/utils/Color_resources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboardmainscreen extends StatefulWidget {
  const Dashboardmainscreen({super.key});

  @override
  State<Dashboardmainscreen> createState() => _DashboardmainscreenState();
}

class _DashboardmainscreenState extends State<Dashboardmainscreen> {
  late DateTime _currentDate = DateTime.now();
  late bool streakVisible = false;
  late List<DateTime> _dates;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      streakOpen();
    });
    _dates = _generateDateList();
    findUserByEmail("devahari420@gmail.com");
    _scrollController = ScrollController();
  }

  Future<QueryDocumentSnapshot<Object?>?> findUserByEmail(String email) async {
    try {
      // Reference to the collection where users are stored
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');

      // Query to find the document with the matching email
      QuerySnapshot querySnapshot =
          await usersCollection.where('email', isEqualTo: email).limit(1).get();

      // Check if any documents match the query
      if (querySnapshot.docs.isNotEmpty) {
        print(querySnapshot.docs.first.data());
        return querySnapshot.docs.first;
      } else {
        debugPrint("No user found with email: $email");
        return null;
      }
    } catch (e) {
      debugPrint("Error finding user: $e");
      return null;
    }
  }

  List<DateTime> _generateDateList() {
    List<DateTime> dates = [];
    for (int i = 90; i > 0; i--) {
      dates.add(_currentDate.subtract(Duration(days: i)));
    }
    dates.add(_currentDate);
    for (int i = 1; i <= 2; i++) {
      dates.add(_currentDate.add(Duration(days: i)));
    }
    return dates;
  }

  String _formatDate(DateTime date) {
    return date.day.toString().padLeft(2, '0');
  }

  String _formatMonth(DateTime date) {
    return DateFormat('EEEE').format(date).split('')[0];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void streakOpen() {
    if (!streakVisible) {
      setState(() {
        streakVisible = true; // Mark as shown for the current session
      });
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return const StreakScreen(title: "Cal AI", message: "Day streak");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: GREY2,
      appBar: AppBar(
        backgroundColor: GREY2,
        actions: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Cal AI",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                  color: WHITE, borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 5.0, 14.0, 5.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return const StreakScreen(
                            title: "Cal AI", message: "Day streak");
                      },
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/images/fireflame.png'),
                        width: 15,
                        height: 15,
                        fit: BoxFit.fill,
                      ),
                      Spacer(),
                      Text(
                        "0",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.07,
              width: double.infinity,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  DateTime date = _dates[index];
                  bool isSelected = date.isAtSameMomentAs(_currentDate);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentDate = date;
                      });
                    },
                    child: Center(
                      child: Container(
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatMonth(date),
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? BLACK : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: isSelected ? BLACK : Colors.transparent,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: Text(
                                  _formatDate(date),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: size.height * 0.15,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                  color: WHITE, borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: SizedBox(
                  width: size.width * 0.7,
                  child: Row(
                    children: [
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "1198",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Calories left",
                            style: TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                      const Spacer(),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 90,
                            width: 90,
                            child: CircularProgressIndicator(
                              value: 0.0,
                              strokeWidth: 4,
                              backgroundColor: Colors.grey.shade300,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(GREY),
                            ),
                          ),
                          const Image(
                            image:
                                AssetImage("assets/images/fireflame_black.png"),
                            height: 30,
                            width: 30,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: size.height * 0.17,
                        width: size.width * 0.28,
                        decoration: BoxDecoration(
                            color: WHITE,
                            border: Border.all(width: 1, color: WHITE),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "142g",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const Text("Protiens left",
                                  style: TextStyle(fontSize: 10)),
                              const Spacer(),
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
                                          value: 0.0,
                                          strokeWidth: 4,
                                          backgroundColor: Colors.grey.shade300,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(GREY),
                                        ),
                                      ),
                                      const Image(
                                        image: AssetImage(
                                            "assets/images/thunder_color.png"),
                                        height: 30,
                                        width: 30,
                                      )
                                      // const Text(
                                      //   '70', // Text to display
                                      //   style: TextStyle(
                                      //     fontSize: 18,
                                      //     fontWeight: FontWeight.bold,
                                      //     color: Colors.black,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: size.height * 0.17,
                        width: size.width * 0.28,
                        decoration: BoxDecoration(
                            color: WHITE,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "256g",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const Text("Carbs left",
                                  style: TextStyle(fontSize: 10)),
                              const Spacer(),
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
                                          value: 0.0,
                                          strokeWidth: 4,
                                          backgroundColor: Colors.grey.shade300,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(GREY),
                                        ),
                                      ),
                                      const Image(image: AssetImage("assets/images/grains.png"),height: 30,width: 30,)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: size.height * 0.17,
                        width: size.width * 0.28,
                        decoration: BoxDecoration(
                            color: WHITE,
                            border: Border.all(width: 1, color: WHITE),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "59g",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const Text("Fats left",
                                  style: TextStyle(fontSize: 10)),
                              const Spacer(),
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
                                          value: 0.0,
                                          strokeWidth: 4,
                                          backgroundColor: Colors.grey.shade300,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(GREY),
                                        ),
                                      ),
                                      const Image(image: AssetImage("assets/images/droplet.png"),height: 30,width: 30,)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Recently eaten",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: size.width * 1,
                    decoration: BoxDecoration(
                        color: GREY2, borderRadius: BorderRadius.circular(15)),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            "You haven't uploaded any food",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "Start tracking Monday's meals by taking a quick pictures")
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
