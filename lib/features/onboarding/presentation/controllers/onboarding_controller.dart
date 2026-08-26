import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../data/models/onboarding_model.dart';

/// Onboarding slide content, localized. Update the ARB keys
/// (onboard1Title/Subtitle, etc.) to change copy — the UI widgets just
/// render whatever this list provides.
class OnboardingController extends Notifier<List<OnboardingModel>> {
  @override
  List<OnboardingModel> build() => const [];

  List<OnboardingModel> slidesFor(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      OnboardingModel(
        title: l10n.onboard1Title,
        description: l10n.onboard1Subtitle,
        imagePath: 'assets/onboard/onboard1.png',
      ),
      OnboardingModel(
        title: l10n.onboard2Title,
        description: l10n.onboard2Subtitle,
        imagePath: 'assets/onboard/onboard2.png',
      ),
      OnboardingModel(
        title: l10n.onboard3Title,
        description: l10n.onboard3Subtitle,
        imagePath: 'assets/onboard/onboard3.png',
      ),
    ];
  }
}

final onboardingControllerProvider =
NotifierProvider<OnboardingController, List<OnboardingModel>>(OnboardingController.new);