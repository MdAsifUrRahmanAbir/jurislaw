part of '../views/home_view.dart';

class HomeTopRated extends GetView<HomeController> {
  const HomeTopRated({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
          child: Text(
            'top_rated'.tr,
            style: const TextStyle(
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
    );
  }
}
