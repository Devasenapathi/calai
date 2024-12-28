import 'package:calai/utils/Color_resources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboardmainscreen extends StatefulWidget {
  const Dashboardmainscreen({super.key});

  @override
  State<Dashboardmainscreen> createState() => _DashboardmainscreenState();
}

class _DashboardmainscreenState extends State<Dashboardmainscreen> {
  late DateTime _currentDate = DateTime.now();

  // Create a list of dates (past 3 days, today, and next 3 days)
  late List<DateTime> _dates;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _dates = _generateDateList();
    _scrollController = ScrollController();
  }

  List<DateTime> _generateDateList() {
    List<DateTime> dates = [];
    for (int i = 3; i > 0; i--) {
      dates.add(_currentDate.subtract(Duration(days: i)));
    }
    dates.add(_currentDate);
    for (int i = 1; i <= 90; i++) {
      dates.add(_currentDate.add(Duration(days: i)));
    }
    return dates;
  }

  String _formatDate(DateTime date) {
    return date.day.toString().padLeft(2, '0');
  }

  String _formatMonth(DateTime date){
    return DateFormat('EEEE').format(date).split('')[0];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
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
                          Text(_formatMonth(date),
                          style: TextStyle(
                              fontSize: 14,
                              color: isSelected ? BLACK : Colors.black,
                            ),
                            textAlign: TextAlign.center,),
                          Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                        color: isSelected ? BLACK : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                            child: Text(
                              _formatDate(date),
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                              textAlign: TextAlign.center,
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
          const SizedBox(height: 10,),
          Container(
            height: size.height * 0.15,
            width: size.width * 0.9,
            decoration: BoxDecoration(
              color: WHITE,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Center(
              child: SizedBox(
                width: size.width * 0.7,
                child: Row(
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("1198", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        Text("Calories left")
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: CircularProgressIndicator(
                      value: 0.0,
                      strokeWidth: 5,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                      WHITE
                      ),
                    ),                    
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                height: 50,
                width: 30,
                decoration: BoxDecoration(
                  border: Border.all(width: 1)
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}