import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import 'package:my_structure/app/widgets/lawyer_card.dart';
import 'package:my_structure/app/core/services/local_storage_service.dart';
import 'package:my_structure/app/routes/app_pages.dart';
import 'package:my_structure/app/data/models/lawyer_model.dart';
import '../controllers/home_controller.dart';


part 'home_mobile.dart';
part 'home_tab.dart';
part '../widgets/home_hero.dart';
part '../widgets/home_categories.dart';
part '../widgets/home_nearby_lawyers.dart';
part '../widgets/home_top_rated.dart';
part '../widgets/nearby_lawyer_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const HomeTab();
        }
        return const HomeMobile();
      },
    );
  }
}
