import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import 'package:my_structure/app/widgets/primary_button.dart';
import 'package:my_structure/app/widgets/primary_input_field.dart';
import '../../../../widgets/primary_dropdown.dart';
import '../controllers/registration_controller.dart';
part 'registration_mobile.dart';
part 'registration_tab.dart';
part '../widgets/registration_header.dart';
part '../widgets/registration_fields.dart';
part '../widgets/registration_address_info.dart';
part '../widgets/registration_profile_pic.dart';
part '../widgets/registration_button.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const RegistrationTab();
        }
        return const RegistrationMobile();
      },
    );
  }
}
