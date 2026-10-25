import 'package:flutter/material.dart';
import '../../data/models/onboarding_model.dart';

/// One full-bleed onboarding slide — image fills the entire screen,
/// title + description overlaid near the bottom. Used as the PageView's
/// itemBuilder inside the full-screen Stack in OnboardingScreen.
class OnboardingItemWidget extends StatelessWidget {
  final OnboardingModel data;

  const OnboardingItemWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          data.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: const Icon(Icons.image_outlined, color: Colors.grey, size: 48),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 140, // clears the step indicator + CTA button overlay
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}