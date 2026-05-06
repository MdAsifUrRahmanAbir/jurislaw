part of 'home_view.dart';

class HomeMobile extends GetView<HomeController> {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text('app_name'.tr, style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: AppColors.gold),
            onPressed: () => _showLanguageDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHero(),

            SizedBox(height: AppSizes.gapMid),

            HomeCategories(),

            SizedBox(height: AppSizes.gapMid),

            HomeNearbyLawyers(),

            SizedBox(height: AppSizes.gapMid),

            HomeTopRated(),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('select_language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('bangla'.tr),
              onTap: () {
                LocalStorage.saveLanguage(name: 'Bangla', langSmall: 'bn', langCap: 'BN');
                Get.updateLocale(const Locale('bn'));
                Get.back();
              },
            ),
            ListTile(
              title: Text('english'.tr),
              onTap: () {
                LocalStorage.saveLanguage(name: 'English', langSmall: 'en', langCap: 'EN');
                Get.updateLocale(const Locale('en'));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
