import 'package:flutter/material.dart';

class OnboardingViewModel with ChangeNotifier {
  final PageController pageController = PageController();
  int _currentPage = 0;

  int get currentPage => _currentPage;

  void nextPage() {
    if (_currentPage < 2) {
      _currentPage++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void skip() {
    _currentPage = 2;
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void onPageChanged(int page) {
    _currentPage = page;
    notifyListeners();
  }
}