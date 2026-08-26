import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/custom_tab_bar.dart';
import '../controllers/bookings_controller.dart';
import '../widgets/bookings_list.dart';

class BookingsMobileView extends ConsumerStatefulWidget {
  const BookingsMobileView({super.key});

  @override
  ConsumerState<BookingsMobileView> createState() => _BookingsMobileViewState();
}

class _BookingsMobileViewState extends ConsumerState<BookingsMobileView> with SingleTickerProviderStateMixin {
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
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
    );
  }
}
