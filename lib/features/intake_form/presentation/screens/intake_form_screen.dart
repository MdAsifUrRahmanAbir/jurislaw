import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/utils/responsive.dart';
import 'intake_form_mobile_view.dart';
import 'intake_form_tab_view.dart';

class IntakeFormScreen extends ConsumerWidget {
  const IntakeFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Responsive(
        mobile: const IntakeFormMobileView(),
        tablet: const IntakeFormTabView(),
      ),
    );
  }
}
