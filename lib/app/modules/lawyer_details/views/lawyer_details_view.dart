import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import 'package:my_structure/app/widgets/primary_button.dart';
import '../controllers/lawyer_details_controller.dart';
import '../widgets/lawyer_details_widgets.dart';

part 'lawyer_details_mobile.dart';
part 'lawyer_details_tab.dart';

class LawyerDetailsView extends GetView<LawyerDetailsController> {
  const LawyerDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const LawyerDetailsTab();
        }
        return const LawyerDetailsMobile();
      },
    );
  }
}
