import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/state/paged_list_state.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/custom_tab_bar.dart';
import '../../../../core/widgets/utility/empty_state.dart';
import '../../../../core/widgets/utility/paged_list_view.dart';
import '../../../../routes/route_names.dart';
import '../../../main_shell/presentation/controllers/main_shell_controller.dart';
import '../../data/models/booking_model.dart';
import '../controllers/bookings_controller.dart';
import '../widgets/booking_list_item.dart';

/// My bookings (A5.1) — Upcoming (still active) and Past (finished) tabs.
/// [maxWidth] centers the content on wider screens.
class BookingsMobileView extends ConsumerStatefulWidget {
  final double maxWidth;

  const BookingsMobileView({super.key, this.maxWidth = double.infinity});

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

  PagedListState<BookingModel> _filtered(PagedListState<BookingModel> state, bool past) =>
      state.copyWith(items: state.items.where((b) => b.isFinished == past).toList(), errorMessage: state.errorMessage);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingsControllerProvider);
    final controller = ref.read(bookingsControllerProvider.notifier);

    Widget list(bool past) => PagedListView<BookingModel>(
          state: _filtered(state, past),
          onRefresh: controller.refresh,
          onLoadMore: controller.loadMore,
          onRetryMore: controller.retryMore,
          padding: const EdgeInsets.all(AppSizes.md),
          empty: EmptyState(
            icon: Icons.event_busy_rounded,
            title: past ? 'No past consultations' : 'No upcoming consultations',
            message: past ? 'Consultations you complete or cancel will show up here.' : 'Find an advocate and book a slot to get started.',
            actionLabel: past ? null : 'Find an Advocate',
            onAction: past ? null : () => ref.read(mainShellControllerProvider.notifier).selectTab(1),
          ),
          itemBuilder: (context, booking, _) => BookingListItem(
            booking: booking,
            onTap: () => context.push(RouteNames.bookingDetailsPath(booking.id)),
          ),
        );

    return SafeArea(
      child: Column(
        children: [
          const CustomAppBar(title: 'My Bookings', showBack: false),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: widget.maxWidth),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                      child: CustomTabBar(controller: _tabController, tabs: const [Tab(text: 'Upcoming'), Tab(text: 'Past')]),
                    ),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [list(false), list(true)]),
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
