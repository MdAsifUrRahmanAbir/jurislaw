part of '../views/home_view.dart';

class HomeNearbyLawyers extends GetView<HomeController> {
  const HomeNearbyLawyers({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
          child: Text(
            'nearby_you'.tr,
            style: const TextStyle(
              fontSize: AppSizes.fontLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSizes.gapSmall),
        SizedBox(
          height: 249,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
              itemCount: controller.lawyers.length,
              itemBuilder: (context, index) {
                final lawyer = controller.lawyers[index];
                return NearbyLawyerCard(lawyer: lawyer);
              },
            ),
          ),
        ),
      ],
    );
  }
}
