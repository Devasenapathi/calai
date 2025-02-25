import 'package:calai/Screens/CustomerDetailsCollect.dart/CustomerDetailsCollect.dart';
import 'package:calai/utils/Color_resources.dart';
import 'package:flutter/material.dart';

class StepersScreen extends StatefulWidget {
  const StepersScreen({super.key});

  @override
  State<StepersScreen> createState() => _StepersScreenState();
}

class _StepersScreenState extends State<StepersScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _steps = [
    {
      'title': 'Step 1',
      'description': 'Welcome to the app! This is the first step.',
      'image': 'assets/images/calai2.webp'
    },
    {
      'title': 'Step 2',
      'description': 'Now you will learn how to navigate through the app.',
      'image': 'assets/images/calai3.webp'
    },
    {
      'title': 'Step 3',
      'description': 'Finally, explore advanced features of the app.',
      'image': 'assets/images/athelete.webp'
    },
  ];

  void _goToNextPage() {
    if (_currentIndex < _steps.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              const CustomerDetailsCollectScreen()));
    }
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _steps.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: _currentIndex == index ? 12 : 8,
          height: _currentIndex == index ? 12 : 8,
          decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.black : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: BLACK,
      body: Stack(
        children: [
          // Increased Image Height
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: size.height * 0.55, // Increased height
              child: Image.asset(
                _steps[_currentIndex]['image']!,
                width: size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlapping Card
          Positioned(
            top: size.height * 0.45, // Overlaps with the image
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: WHITE,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Swipeable Content inside the card
                  SizedBox(
                    height: size.height * 0.25, // Adjust content height
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _steps.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              _steps[index]['title']!,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            Text(_steps[index]['description']!),
                          ],
                        );
                      },
                    ),
                  ),
                  Spacer(),

                  // Custom Dots Indicator
                  _buildDots(),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: WHITE,
                      backgroundColor: BLACK,
                      shadowColor: GREY,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0)),
                      minimumSize: Size(size.width * 1, 50),
                    ),
                    onPressed: _goToNextPage,
                    child: Text(
                        _currentIndex < _steps.length - 1 ? 'Next' : 'Finish'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
