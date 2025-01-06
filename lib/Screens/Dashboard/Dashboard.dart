import 'package:calai/Screens/Analytics/Analytics.dart';
import 'package:calai/Screens/Dashboard/Components/DashboardMainScreen.dart';
import 'package:calai/Screens/Dashboard/Components/StreakScreen.dart';
import 'package:calai/Screens/Settings/Settings.dart';
import 'package:calai/utils/Color_resources.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
    int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    const Dashboardmainscreen(),
    const AnalyticsScreen(),
    const SettingsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FAB pressed!');
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        backgroundColor: BLACK,
        child: const Icon(
          Icons.add,
          color: WHITE,
        ),
      ),

      resizeToAvoidBottomInset: false,
      
      bottomNavigationBar: BottomAppBar(
        padding:const EdgeInsets.all(0),
        clipBehavior: Clip.antiAlias,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          fixedColor: BLACK,
          backgroundColor:WHITE,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics),
              label: 'Analytics',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
      
      body: _pages[_selectedIndex]
    );
  }
}
