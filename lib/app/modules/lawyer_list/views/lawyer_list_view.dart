import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import 'package:my_structure/app/widgets/primary_button.dart';
import 'package:my_structure/app/widgets/lawyer_card.dart';
import '../controllers/lawyer_list_controller.dart';
import '../widgets/filter_chip_widget.dart';

part 'lawyer_list_mobile.dart';
part 'lawyer_list_tab.dart';

class LawyerListView extends GetView<LawyerListController> {
  const LawyerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const LawyerListTab();
        }
        return const LawyerListMobile();
      },
    );
  }
}
