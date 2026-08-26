import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/custom_tab_bar.dart';
import '../controllers/bookings_controller.dart';
import '../widgets/bookings_list.dart';

/// Same content as [BookingsMobileView], centered in a fixed-width
/// column for wider (tablet/web) viewports.
class BookingsTabView extends ConsumerStatefulWidget {
  const BookingsTabView({super.key});

  @override
  ConsumerState<BookingsTabView> createState() => _BookingsTabViewState();
}

class _BookingsTabViewState extends ConsumerState<BookingsTabView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(bookingsControllerProvider);
    final controller = ref.read(bookingsControllerProvider.notifier);

    return SafeArea(
      child: Column(
        children: [
          const CustomAppBar(title: 'My Bookings', showBack: false),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
                      child: CustomTabBar(controller: _tabController, tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Past')]),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          BookingsList(bookings: controller.upcoming, isPast: false),
                          BookingsList(bookings: controller.past, isPast: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
