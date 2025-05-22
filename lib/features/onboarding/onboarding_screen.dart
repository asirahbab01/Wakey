import 'package:flutter/material.dart';
import 'package:wakey/common_widgets/onboarding_page.dart';
import '../location/location_access_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': "Sync with Nature's Rhythm",
      'description':
          "Experience a peaceful transition into the evening with an alarm that aligns with the sunset. Your perfect reminder, always 15 minutes before sundown.",
      'image': 'assets/onboard-1.gif',
    },
    {
      'title': "Effortless & Automatic",
      'description':
          "No manual setup needed. Your alarm automatically syncs with your location and the sunset time every day.",
      'image': 'assets/onboard-2.gif',
    },
    {
      'title': "Relax & Unwind",
      'description':
          "Let go of stress and enjoy your evenings. Our app helps you wind down and prepare for restful sleep.",
      'image': 'assets/onboard-3.gif',
    },
  ];

  void _goToLocationAccess() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LocationAccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232428),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _goToLocationAccess,
            child: const Text("Skip", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  children: [
                    SizedBox(
                      height:
                          constraints.maxHeight * 0.7, // Show most of the page
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: onboardingData.length,
                        onPageChanged: (index) =>
                            setState(() => _currentPage = index),
                        itemBuilder: (context, index) {
                          final data = onboardingData[index];
                          return OnboardingPage(
                            title: data['title']!,
                            description: data['description']!,
                            imagePath: data['image']!,
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 16),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.purple
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (_currentPage == onboardingData.length - 1) {
                              _goToLocationAccess();
                            } else {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
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
}
