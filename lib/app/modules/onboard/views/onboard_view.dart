import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import '../controllers/onboard_controller.dart';
import '../widgets/onboard_page.dart';

part 'onboard_mobile.dart';
part 'onboard_tab.dart';

class OnboardView extends GetView<OnboardController> {
  const OnboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const OnboardTab();
        }
        return const OnboardMobile();
      },
    );
  }
}
