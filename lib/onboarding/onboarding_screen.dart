import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_structure/app/core/services/local_storage_service.dart';
import 'package:my_structure/app/routes/app_pages.dart';

import 'model/onboarding_item.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/page_indicator.dart';
import 'widgets/navigation_buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  final List<OnboardingItem> _items = const [
    OnboardingItem(
      image: 'assets/onboard/onboard1.png',
      titleKey: 'onboard_1_title',
      descKey: 'onboard_1_subtitle',
    ),
    OnboardingItem(
      image: 'assets/onboard/onboard2.png',
      titleKey: 'onboard_2_title',
      descKey: 'onboard_2_subtitle',
    ),
    OnboardingItem(
      image: 'assets/onboard/onboard3.png',
      titleKey: 'onboard_3_title',
      descKey: 'onboard_3_subtitle',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache onboarding images for premium lag-free performance
    for (final item in _items) {
      precacheImage(AssetImage(item.image), context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _skip() {
    _pageController.animateToPage(
      _items.length - 1,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _back() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _getStarted() async {
    // 1. Save onboarding completed state in SharedPreferences as required
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    // 2. Also keep GetStorage local cache helper in sync so splash screen redirects correctly
    await LocalStorage.setOnboardDone(value: true);

    // 3. Navigate to Login using existing route definition
    Get.offAllNamed(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Centered PageView for sliding images naturally
            Positioned.fill(
              bottom: 260, // Leave space for bottom UI overlay
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPage(item: _items[index]);
                },
              ),
            ),

            // Fixed Overlay UI at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: isDark ? const Color(0xFF121212) : Colors.white,
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title with Fade Transition
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Padding(
                        key: ValueKey<int>(_currentIndex),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _items[_currentIndex].titleKey.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF0B1F3A),
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description with Fade Transition
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Padding(
                        key: ValueKey<int>(_currentIndex),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          _items[_currentIndex].descKey.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Page Indicator
                    PageIndicator(
                      count: _items.length,
                      currentIndex: _currentIndex,
                    ),
                    const SizedBox(height: 12),

                    // Navigation Buttons
                    NavigationButtons(
                      currentIndex: _currentIndex,
                      totalPages: _items.length,
                      onSkip: _skip,
                      onNext: _next,
                      onBack: _back,
                      onGetStarted: _getStarted,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
