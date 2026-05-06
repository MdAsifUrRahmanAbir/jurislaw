part of '../views/home_view.dart';

class HomeCategories extends GetView<HomeController> {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMid),
          child: Text(
            'select_category'.tr,
            style: const TextStyle(
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
      ],
    );
  }
}
