import 'package:calai/Screens/Dashboard/Components/DashboardMainScreen.dart';
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
    const Center(child: Text('Home Page')),
    const Center(child: Text('Search Page')),
    const Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY1,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FAB pressed!');
        },
        backgroundColor: BLACK,
        child: const Icon(Icons.add,color: WHITE,),
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          backgroundColor: GREY1,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),


      appBar: AppBar(
        backgroundColor: GREY1,
        actions: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Cal AI",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                color: WHITE,
                borderRadius: BorderRadius.circular(50)
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(14.0,5.0,14.0,5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("1"),
                    SizedBox(width: 10,),
                    Text("0")
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: const Dashboardmainscreen(),
    ) ;
  }
}