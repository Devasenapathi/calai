import 'package:calai/utils/Color_resources.dart';
import 'package:flutter/material.dart';

class HeightSelectorScreen extends StatefulWidget {
  const HeightSelectorScreen({super.key});

  @override
  _HeightSelectorScreenState createState() => _HeightSelectorScreenState();
}

class _HeightSelectorScreenState extends State<HeightSelectorScreen> {
  int feet = 5;  // Default feet value
  int inches = 0;  // Default inches value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Height"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Select Height",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Feet Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Feet: ", style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 100,
                  width: 80,
                  // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    diameterRatio: 1.5,
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        bool isSelected = (index + 3) == feet;
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isSelected ? GREY1 : Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 3} ft',  // Feet from 3 to 10
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        );
                      },
                      childCount: 8,  // From 3 feet to 10 feet
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        feet = index + 3;  // Update the feet value
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Inches Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Inches: ", style: TextStyle(fontSize: 18)),
                Container(
                  height: 100,
                  width: 80,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: ListWheelScrollView.useDelegate(
                    itemExtent: 50,
                    diameterRatio: 1.5,
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        return Center(
                          child: Text(
                            '$index in',  // Inches from 0 to 11
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      },
                      childCount: 12,  // From 0 inches to 11 inches
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        inches = index;  // Update the inches value
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Display Selected Height
            Text(
              "Selected Height: $feet ft $inches in",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // Optional: Button to confirm the selection
            ElevatedButton(
              onPressed: () {
                // Show the selected height in an alert dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Selected Height"),
                      content: Text("Height: $feet ft $inches in"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Confirm Height"),
            ),
          ],
        ),
      ),
    );
  }
}







class ProgressCardGrid extends StatelessWidget {
  const ProgressCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid with Cards')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 cards in a row
            crossAxisSpacing: 10, // Horizontal space between cards
            mainAxisSpacing: 10, // Vertical space between cards
          ),
          itemCount: 4, // Total 4 cards
          itemBuilder: (context, index) {
            // Card with fixed height and width
            return SizedBox(
              width: 50.0, // Set width of each card
              height: 50.0, // Set height of each card
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    // Circular Progress Bar with Different Colors
                    Center(
                      child: CircularProgressIndicator(
                        value: 0.7, // Adjust the progress value
                        strokeWidth: 8,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(index)),
                      ),
                    ),
                    // Positioned Editable Icon (Edit icon at bottom right)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
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
    );
  }

  // Function to get different colors for each progress circle
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
}

void main() {
  runApp(MaterialApp(
    home: ProgressCardGrid(),
  ));
}



class DateScroller extends StatefulWidget {
  const DateScroller({super.key});

  @override
  _DateScrollerState createState() => _DateScrollerState();
}

class _DateScrollerState extends State<DateScroller> {
  // Get today's date
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

  // Function to generate a list of dates
  List<DateTime> _generateDateList() {
    List<DateTime> dates = [];
    // Add past 3 days
    for (int i = 3; i > 0; i--) {
      dates.add(_currentDate.subtract(Duration(days: i)));
    }
    // Add current date
    dates.add(_currentDate);
    // Add next 3 days
    for (int i = 1; i <= 90; i++) {
      dates.add(_currentDate.add(Duration(days: i)));
    }
    return dates;
  }

  // Format the date to display as day and month
  String _formatDate(DateTime date) {
    return date.day.toString().padLeft(2, '0');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Select a Date',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Horizontal scrolling alternative
          Container(
            height: 100, // Adjust the height
            width: double.infinity, // Full width
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 1),
            ),
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
                  child: Container(
                    width: 80, // Adjust width of each item
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _formatDate(date),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          // Display the full selected date
          Text(
            'Selected Date: ${_formatDate(_currentDate)}',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
