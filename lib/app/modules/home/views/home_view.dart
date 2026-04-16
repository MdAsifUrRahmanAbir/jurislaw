import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/lawyer_card.dart';
import '../../../core/services/local_storage_service.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/lawyer_model.dart';
import '../../../routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section or similar
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingMid),
              width: double.infinity,
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'home'.tr,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('search_hint'.tr, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                ],
              ),
            ),

            const SizedBox(height: AppSizes.gapMid),

            // Select Category Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
              child: Text(
                'Select Category',
                style: TextStyle(
                  fontSize: AppSizes.fontLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.gapSmall),
            SizedBox(
              height: 45,
              child: Obx(
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    final isSelected = controller.selectedCategory.value == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSizes.gapSmall),
                      child: GestureDetector(
                        onTap: () => controller.selectedCategory.value = category,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.paddingLarge,
                            vertical: AppSizes.paddingXSmall,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.gold : AppColors.chipBackground,
                            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                            border: Border.all(
                              color: isSelected ? AppColors.gold : AppColors.divider,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: AppSizes.gapXXLarge),

            // Nearby You Section (Horizontal)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
              child: Text(
                'Nearby You',
                style: TextStyle(
                  fontSize: AppSizes.fontLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.gapSmall),
            SizedBox(
              height: 240,
              child: Obx(
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
                  itemCount: controller.lawyers.length,
                  itemBuilder: (context, index) {
                    final lawyer = controller.lawyers[index];
                    return _NearbyLawyerCard(lawyer: lawyer);
                  },
                ),
              ),
            ),

            const SizedBox(height: AppSizes.gapXXLarge),

            // List of Lawyers (Vertical)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
              child: Text(
                'Top Rated',
                style: TextStyle(
                  fontSize: AppSizes.fontLarge,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.gapSmall),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
                itemCount: controller.lawyers.length,
                itemBuilder: (context, index) {
                  final lawyer = controller.lawyers[index];
                  return LawyerCard(lawyer: lawyer);
                },
              ),
            ),
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
              title: const Text('Bangla (বাংলা)'),
              onTap: () {
                LocalStorage.saveLanguage(name: 'Bangla', langSmall: 'bn', langCap: 'BN');
                Get.back();
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                LocalStorage.saveLanguage(name: 'English', langSmall: 'en', langCap: 'EN');
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NearbyLawyerCard extends StatelessWidget {
  final Lawyer lawyer;
  const _NearbyLawyerCard({required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.lawyerDetails, arguments: lawyer),
      child: Container(
        width: 250,
        margin: const EdgeInsets.only(right: AppSizes.gapMid, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSizes.radiusMid)),
                  image: DecorationImage(
                    image: NetworkImage(lawyer.photo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMid),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lawyer.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      lawyer.specialty,
                      style: const TextStyle(color: AppColors.gold, fontSize: 12),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: AppColors.gold, size: 14),
                            Text(' ${lawyer.rating}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text('৳${lawyer.fee}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
