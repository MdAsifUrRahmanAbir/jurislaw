import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../widgets/intake_form_body.dart';

/// Same content as [IntakeFormMobileView], centered in a fixed-width
/// column for wider (tablet/web) viewports.
class IntakeFormTabView extends StatelessWidget {
  const IntakeFormTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const CustomAppBar(title: 'Describe Your Issue'),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: IntakeFormBody(
                    onSubmitted: () {
                      CustomSnackbar.show(
                        context,
                        'Your legal issue has been submitted. We are matching you with the best advocates.',
                      );
                      context.pop();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
