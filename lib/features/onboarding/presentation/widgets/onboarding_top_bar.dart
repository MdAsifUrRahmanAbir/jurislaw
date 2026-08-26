import 'package:flutter/material.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/widgets/common/link_button.dart';

/// Top-left "Skip" action shown above the onboarding carousel.
class OnboardingTopBar extends StatelessWidget {
  final VoidCallback? onSkip;

  const OnboardingTopBar({super.key, this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: LinkButton(
        label: AppLocalizations.of(context)!.skip,
        onPressed: onSkip,
      ),
    );
  }
}