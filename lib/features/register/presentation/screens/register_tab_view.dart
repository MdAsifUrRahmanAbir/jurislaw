import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../routes/route_names.dart';
import '../widgets/register_header.dart';
import '../widgets/register_form.dart';

/// Same content as [RegisterMobileView], centered in a fixed-width
/// column for wider (tablet/web) viewports.
class RegisterTabView extends ConsumerWidget {
  const RegisterTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(title: AppLocalizations.of(context)!.completeProfileTitle),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.xl),
                  child: CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RegisterHeader(),
                        const SizedBox(height: AppSizes.lg),
                        RegisterForm(onComplete: () => context.go(RouteNames.mainShell)),
                      ],
                    ),
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
