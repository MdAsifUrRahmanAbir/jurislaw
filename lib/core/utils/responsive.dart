import 'package:flutter/material.dart';
import 'package:ukil_chaai/core/constants/app_sizes.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  const Responsive({super.key, required this.mobile, required this.tablet});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= AppSizes.mobileBreakpoint) return SafeArea(child: tablet);
      return SafeArea(child: mobile);
    });
  }
}
