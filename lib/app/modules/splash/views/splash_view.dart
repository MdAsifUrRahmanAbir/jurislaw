import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import 'package:my_structure/app/core/constants/app_strings.dart';
import '../controllers/splash_controller.dart';

part 'splash_mobile.dart';
part 'splash_tab.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const SplashTab();
        }
        return const SplashMobile();
      },
    );
  }
}
