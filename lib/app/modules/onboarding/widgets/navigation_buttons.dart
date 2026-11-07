import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationButtons extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onGetStarted;

  const NavigationButtons({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onSkip,
    required this.onNext,
    required this.onBack,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentIndex == totalPages - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Button (Skip or Back)
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: isLastPage ? onBack : onSkip,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Text(
                  isLastPage ? 'back'.tr : 'skip'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Right Button (Next or Get Started)
          ElevatedButton(
            onPressed: isLastPage ? onGetStarted : onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLastPage
                  ? const Color(0xFFD4A017) // Gold Accent
                  : const Color(0xFF0B1F3A), // Primary Navy
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: Text(
              isLastPage ? 'get_started'.tr : 'next'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
