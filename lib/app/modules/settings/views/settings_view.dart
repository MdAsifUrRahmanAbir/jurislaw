import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import 'package:my_structure/app/core/constants/app_strings.dart';
import 'package:my_structure/app/core/services/local_storage_service.dart';
import 'package:my_structure/app/widgets/primary_appbar_widget.dart';
import 'package:my_structure/app/widgets/toggle_switch_widget.dart';
import '../controllers/settings_controller.dart';
import '../widgets/settings_widgets.dart';

part 'settings_mobile.dart';
part 'settings_tab.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const SettingsTab();
        }
        return const SettingsMobile();
      },
    );
  }
}
