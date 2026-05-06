import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../widgets/primary_appbar_widget.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_input_field.dart';
import '../controllers/update_profile_controller.dart';

part 'update_profile_mobile.dart';
part 'update_profile_tab.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  const UpdateProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(  
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const UpdateProfileTab();
        }
        return const UpdateProfileMobile();
      },
    );
  }
}
