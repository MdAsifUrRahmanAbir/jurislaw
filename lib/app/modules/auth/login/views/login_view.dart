import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import 'package:my_structure/app/core/constants/app_strings.dart';
import 'package:my_structure/app/widgets/primary_button.dart';
import 'package:my_structure/app/widgets/primary_input_field.dart';
import 'package:my_structure/app/widgets/rich_text_widget.dart';

import '../controllers/login_controller.dart';

part 'login_mobile.dart';
part 'login_tab.dart';
part '../widgets/login_branding.dart';
part '../widgets/login_header.dart';
part '../widgets/login_fields.dart';
part '../widgets/login_button.dart';
part '../widgets/login_footer.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const LoginTab();
        }
        return const LoginMobile();
      },
    );
  }
}
