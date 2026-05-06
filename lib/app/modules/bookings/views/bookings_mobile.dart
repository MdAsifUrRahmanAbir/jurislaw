part of 'bookings_view.dart';

class BookingsMobile extends StatelessWidget {
  const BookingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text('my_bookings'.tr, style: const TextStyle(color: AppColors.gold)),
          bottom: TabBar(
            indicatorColor: AppColors.gold,
            labelColor: AppColors.gold,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'upcoming'.tr),
              Tab(text: 'past'.tr),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            BookingsListWidget(isPast: false),
            BookingsListWidget(isPast: true),
          ],
        ),
      ),
    );
  }
}
