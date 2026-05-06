part of 'language_selection_view.dart';

class LanguageSelectionMobile extends GetView<LanguageSelectionController> {
  const LanguageSelectionMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.language_rounded, size: 80, color: AppColors.gold),
              const SizedBox(height: 32),
              const Text(
                'Select Language / ভাষা নির্বাচন করুন',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose your preferred language to continue\nএগিয়ে যেতে আপনার পছন্দের ভাষা বেছে নিন',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 48),
              
              LanguageCard(
                label: 'Bangla (বাংলা)',
                subtitle: 'প্রাথমিক ভাষা হিসেবে সেট করা আছে',
                onTap: () => controller.selectLanguage('bn', 'Bangla'),
              ),
              const SizedBox(height: 16),
              LanguageCard(
                label: 'English',
                subtitle: 'Continue with English language',
                onTap: () => controller.selectLanguage('en', 'English'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
