import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ukil_chaai_client/app/core/constants/app_colors.dart';
import 'package:ukil_chaai_client/app/core/constants/app_sizes.dart';
import 'package:ukil_chaai_client/app/core/constants/app_strings.dart';
import 'package:ukil_chaai_client/app/widgets/primary_button.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_widgets.dart';

part 'profile_mobile.dart';
part 'profile_tab.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const ProfileTab();
        }
        return const ProfileMobile();
      },
    );
  }
}
