part of 'bottom_nav_view.dart';

class BottomNavMobile extends GetView<BottomNavController> {
  const BottomNavMobile({super.key});

  static final List<Widget> _pages = [
    const HomeView(),
    const LawyerListView(),
    const BookingsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.intakeForm),
          backgroundColor: AppColors.gold,
          elevation: 4,
          child: const Icon(Icons.add_comment_rounded, color: Colors.white, size: 30),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: isDark ? AppColors.darkCardBackground : Colors.white,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home_rounded, AppStrings.home),
                _buildNavItem(1, Icons.gavel_outlined, Icons.gavel_rounded, 'lawyers'.tr),
                const SizedBox(width: 40), // Gap for FAB
                _buildNavItem(2, Icons.calendar_today_outlined, Icons.calendar_today_rounded, 'bookings'.tr),
                _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded, AppStrings.profile),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    bool isActive = controller.currentIndex.value == index;
    return Expanded(
      child: InkWell(
        onTap: () => controller.changePage(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isActive ? activeIcon : icon, color: isActive ? AppColors.gold : Colors.grey, size: 24),
            Text(label, style: TextStyle(color: isActive ? AppColors.gold : Colors.grey, fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
