part of '../views/home_view.dart';

class HomeHero extends GetView<HomeController> {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
