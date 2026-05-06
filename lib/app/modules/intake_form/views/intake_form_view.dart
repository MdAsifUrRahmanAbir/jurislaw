import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import 'package:my_structure/app/widgets/primary_button.dart';
import '../controllers/intake_form_controller.dart';

part 'intake_form_mobile.dart';
part 'intake_form_tab.dart';

class IntakeFormView extends GetView<IntakeFormController> {
  const IntakeFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const IntakeFormTab();
        }
        return const IntakeFormMobile();
      },
    );
  }
}
