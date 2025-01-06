import 'package:calai/utils/Color_resources.dart';
import 'package:flutter/material.dart';

class StreakScreen extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback? onClose;

  const StreakScreen({
    super.key,
    required this.title,
    required this.message,
    this.onClose,
  });

  @override
  State<StreakScreen> createState() => _StreakScreenState();
}

class _StreakScreenState extends State<StreakScreen> {
  @override
  Widget build(BuildContext context) {
    int currentDay = DateTime.now().weekday;
    List<String> daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    Size size = MediaQuery.of(context).size;

    return Dialog(
      shadowColor: Colors.grey.shade300,
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        height: size.height * 0.49,
        width: size.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(14.0, 0.0, 14.0, 0.0),
                        child: Row(
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
                  )
                ],
              ),
              const SizedBox(height: 10),
              const Image(
                image: AssetImage('assets/images/fireflame.png'),
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
              Text(
                widget.message,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.amber[800],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(7, (index) {
                    bool isSelected = currentDay == index;
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              daysOfWeek[index].substring(0, 1),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.amber[800]
                                    : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const Text(
                "You're on fire! Every day matters for hitting your goal!",
                style: TextStyle(fontSize: 10),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  minimumSize: Size(size.width * 1, 50),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showStreakDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible: true, 
    builder: (context) {
      return StreakScreen(
        title: title,
        message: message,
      );
    },
  );
}