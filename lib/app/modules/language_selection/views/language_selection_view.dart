import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import 'package:my_structure/app/core/constants/app_sizes.dart';
import '../controllers/language_selection_controller.dart';
import '../widgets/language_card.dart';

part 'language_selection_mobile.dart';
part 'language_selection_tab.dart';

class LanguageSelectionView extends GetView<LanguageSelectionController> {
  const LanguageSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const LanguageSelectionTab();
        }
        return const LanguageSelectionMobile();
      },
    );
  }
}
