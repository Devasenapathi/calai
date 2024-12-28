import 'package:calai/Screens/CustomerDetailsCollect.dart/CustomerDetailsCollect.dart';
import 'package:calai/utils/Color_resources.dart';
import 'package:flutter/material.dart';

class StepersScreen extends StatefulWidget {
  const StepersScreen({super.key});

  @override
  State<StepersScreen> createState() => _StepersScreenState();
}

class _StepersScreenState extends State<StepersScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToNextTab() {
    if (_tabController.index < 2) {
      _tabController.animateTo(_tabController.index + 1);
    }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const CustomerDetailsCollectScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BLACK,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTutorialPanel('Step 1', 'Welcome to the app! This is the first step.'),
          _buildTutorialPanel('Step 2', 'Now you will learn how to navigate through the app.'),
          _buildTutorialPanel('Step 3', 'Finally, explore advanced features of the app.'),
        ],
      ),
    );
  }

  Widget _buildTutorialPanel(String title, String description) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center( 
            child: Text(
              title,
              style: const TextStyle(color: WHITE, fontSize: 24),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: size.width*1,
            decoration: const BoxDecoration(
              color: WHITE,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                  const SizedBox(height: 20),
                  Text(description),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: WHITE, backgroundColor: BLACK,
                      shadowColor: GREY,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      minimumSize: Size(size.width * 1, 50),
                    ),
                    onPressed: () {
                      _goToNextTab();
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}