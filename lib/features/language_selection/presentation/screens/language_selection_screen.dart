import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/localization/locale_controller.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../routes/route_names.dart';
import '../controllers/language_selection_controller.dart';
import '../widgets/language_option_card.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Responsive(
        mobile: const LanguageSelectionMobileView(),
        tablet: const LanguageSelectionTabView(),
      ),
    );
  }
}

class _LanguageSelectionBody extends ConsumerWidget {
  final double maxWidth;

  const _LanguageSelectionBody({required this.maxWidth});

  Future<void> _select(BuildContext context, WidgetRef ref, Locale locale) async {
    await ref.read(languageSelectionControllerProvider.notifier).selectLocale(locale);
    if (!context.mounted) return;
    context.go(RouteNames.onboarding);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeControllerProvider);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language_rounded, size: AppSizes.xxl + AppSizes.lg, color: AppColors.primary),
              const SizedBox(height: AppSizes.xl),
              Text(
                l10n.selectLanguageTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                l10n.selectLanguageSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: AppSizes.fontSm),
              ),
              const SizedBox(height: AppSizes.xxl),
              LanguageOptionCard(
                label: l10n.languageBangla,
                subtitle: l10n.languageBanglaSubtitle,
                selected: currentLocale.languageCode == 'bn',
                onTap: () => _select(context, ref, const Locale('bn')),
              ),
              const SizedBox(height: AppSizes.md),
              LanguageOptionCard(
                label: l10n.languageEnglish,
                subtitle: l10n.languageEnglishSubtitle,
                selected: currentLocale.languageCode == 'en',
                onTap: () => _select(context, ref, const Locale('en')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageSelectionMobileView extends StatelessWidget {
  const LanguageSelectionMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: _LanguageSelectionBody(maxWidth: double.infinity));
  }
}

class LanguageSelectionTabView extends StatelessWidget {
  const LanguageSelectionTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: _LanguageSelectionBody(maxWidth: 480));
  }
}
