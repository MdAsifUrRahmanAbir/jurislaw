import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import 'package:my_structure/app/core/constants/app_strings.dart';
import '../../home/views/home_view.dart';
import '../../lawyer_list/views/lawyer_list_view.dart';
import '../../profile/views/profile_view.dart';
import '../../bookings/views/bookings_view.dart';
import 'package:my_structure/app/routes/app_pages.dart';

import '../controllers/bottom_nav_controller.dart';

part 'bottom_nav_mobile.dart';
part 'bottom_nav_tab.dart';

class BottomNavView extends GetView<BottomNavController> {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const BottomNavTab();
        }
        return const BottomNavMobile();
      },
    );
  }
}
