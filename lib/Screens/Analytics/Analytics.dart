import 'package:calai/utils/Color_resources.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<FlSpot> _dataPoints = [];
  String _selectedPeriod = "90 Days";

  @override
  void initState() {
    super.initState();
    _updateDataPoints("90 Days");
  }

  void _updateDataPoints(String period) {
    // Dummy weight data
    final allData = {
      "January": 80.0,
      "February": 85.0,
      "March": 80.0,
      "April": 90.0,
      "May": 95.0,
      "June": 80.0,
      "July": 85.0,
    };

    List<String> months = allData.keys.toList();

    // Filter data based on selected period
    int count = 0;
    switch (period) {
      case "90 Days":
        count = 3;
        break;
      case "6 Months":
        count = 6;
        break;
      case "1 Year":
        count = allData.length;
        break;
    }

    // Convert data into points
    _dataPoints = List.generate(
      count,
      (index) => FlSpot(
        index.toDouble(),
        allData[months[index]]!,
      ),
    );

    setState(() {
      _selectedPeriod = period;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GREY2,
        centerTitle: false,
        title: const Text(
          "Overview",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //first Component
                const Text(
                  "Weight Goal",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                  child: Text(
                    "214 lbs",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Current weight"),
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: size.width * 1,
                  decoration: BoxDecoration(
                      color: WHITE, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "159 lbs",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Try to updateonce in a week so we can adjust your plan to ensure you hit your goal.",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: WHITE,
                          backgroundColor: BLACK,
                          elevation: 1,
                          minimumSize: Size(size.width * 1, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text("Log weight"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  child: Row(
                    children: [
                      Text("Goal Progress",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      Spacer(),
                      Text("57.0%",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      Text(
                        " Goal achieved",
                        style:
                            TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
        
                const SizedBox(height: 16),
                // Buttons
                Container(
                  height: 30,
                  width: size.width * 1,
                  decoration: BoxDecoration(
                    color: GREY2,
                    borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: ["90 Days", "6 Months", "1 Year", "All time"]
                        .map((period) {
                      return ElevatedButton(
                        onPressed: () => _updateDataPoints(period),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          foregroundColor: MaterialStateProperty.all(
                            _selectedPeriod == period ? GREY : GREY1,
                          ),
                          elevation: MaterialStateProperty.all(
                            _selectedPeriod == period ? 3 : 0,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            _selectedPeriod == period ? WHITE : GREY2,
                          ),
                        ),
                        child: Text(
                          period,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        
                Container(
                  height: MediaQuery.of(context).size.height * 0.22,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(
                              show: true,
                              drawVerticalLine: false,
                              horizontalInterval: 1,
                              getDrawingHorizontalLine: (value) {
                                return const FlLine(
                                  color: Colors.grey, // Line color
                                  strokeWidth: 1, // Line width
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                left: BorderSide(color: GREY1, width: 1),
                                bottom: BorderSide(color: GREY1, width: 1),
                                top: BorderSide.none,
                                right: BorderSide.none,
                              ),
                            ),
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toString(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final months = [
                                      "Jan",
                                      "Feb",
                                      "Mar",
                                      "Apr",
                                      "May",
                                      "Jun",
                                      "Jul",
                                      "Aug",
                                      "Sep",
                                      "Oct",
                                      "Nov",
                                      "Dec"
                                    ];
                                    return value.toInt() < months.length
                                        ? Text(
                                            months[value.toInt()],
                                            style: const TextStyle(fontSize: 10),
                                          )
                                        : const Text('');
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                show: true,
                                isStepLineChart: false,
                                spots: _dataPoints,
                                // isCurved: true,
                                barWidth: 1,
                                color: GREY1,
                                // dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Row(
                        children: [
                          Text("Nutrition"),
                          Spacer(),
                          Text(
                            "This week vs previous week",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      Container(
                        height: 30,
                        width: size.width * 1,
                        decoration: BoxDecoration(
                          color: GREY2,
                          borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: ["This week", "Last week", "2 wks. ago", "3 wks.ago"]
                              .map((period) {
                            return ElevatedButton(
                              onPressed: () => _updateDataPoints(period),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(EdgeInsets.zero),
                                foregroundColor: MaterialStateProperty.all(
                                  _selectedPeriod == period ? GREY : GREY1,
                                ),
                                elevation: MaterialStateProperty.all(
                                  _selectedPeriod == period ? 3 : 0,
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  _selectedPeriod == period ? WHITE : GREY2,
                                ),
                              ),
                              child: Text(
                                period,
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
        
        
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(children: [
                            Column(
                              children: [
                                Text("0", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                Text("Total Calories", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                Text("0.0", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                Text("Daily avg.", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),)
                              ],
                            )
                          ],),
                          SizedBox(height: 20,),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.22,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Expanded(
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 1,
                                    getDrawingHorizontalLine: (value) {
                                      return const FlLine(
                                        color: Colors.grey,
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: const Border(
                                      left: BorderSide(color: GREY1, width: 1),
                                      bottom: BorderSide(color: GREY1, width: 1),
                                      top: BorderSide.none,
                                      right: BorderSide.none,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    topTitles: const AxisTitles(
                                        sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toString(),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final months = [
                                            "S","M","T","W","T","F","S"
                                          ];
                                          return Text(
                                                  months[value.toInt()],
                                                  style: const TextStyle(fontSize: 10),
                                                );
                                              // : const Text('');
                                        },
                                      ),
                                    ),
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      show: true,
                                      isStepLineChart: false,
                                      spots: _dataPoints,
                                      // isCurved: true,
                                      barWidth: 1,
                                      color: GREY1,
                                      // dotData: FlDotData(show: true),
                                    ),
                                  ],
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
      ),
    );
  }
}
