import 'package:flutter/material.dart';
import '../model/onboarding_item.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Image.asset(
            item.image,
            fit: BoxFit.fitWidth,
            width: constraints.maxWidth,
          ),
        );
      },
    );
  }
}
