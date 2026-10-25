import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/session/auth_session_controller.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../../core/widgets/utility/custom_loader.dart';
import '../../../../core/widgets/utility/error_state.dart';
import '../../../../routes/route_names.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../../../bookings/presentation/widgets/booking_list_item.dart';
import '../../../lawyer_list/presentation/widgets/advocate_card.dart';
import '../../../main_shell/presentation/controllers/main_shell_controller.dart';
import '../../../notifications/presentation/controllers/notification_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/advocate_search_card.dart';
import '../widgets/dashboard_sections.dart';
import '../widgets/home_header.dart';

/// Client dashboard (A3.1) — search card, consultations that need an
/// answer, stats, today's and upcoming consultations, and recommended
/// advocates. [maxWidth] centers it on wider screens.
class HomeMobileView extends ConsumerWidget {
  final double maxWidth;

  const HomeMobileView({super.key, this.maxWidth = double.infinity});

  void _goToTab(WidgetRef ref, int index) => ref.read(mainShellControllerProvider.notifier).selectTab(index);

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(recommendedAdvocatesProvider);
    ref.read(unreadCountProvider.notifier).refresh();
    try {
      ref.invalidate(dashboardProvider);
      await ref.read(dashboardProvider.future);
    } catch (_) {
      // The error is rendered by the dashboard section itself.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authSessionControllerProvider).user;
    final dashboard = ref.watch(dashboardProvider);
    final advocates = ref.watch(recommendedAdvocatesProvider);
    final unread = ref.watch(unreadCountProvider);

    void openBooking(BookingModel b) => context.push(RouteNames.bookingDetailsPath(b.id));

    Widget bookingList(List<BookingModel> bookings) => Column(
          children: [
            for (final b in bookings)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.sm + AppSizes.xs),
                child: BookingListItem(booking: b, onTap: () => openBooking(b)),
              ),
          ],
        );

    final dashboardSections = dashboard.when(
      loading: () => [const Padding(padding: EdgeInsets.all(AppSizes.xl), child: CustomLoader())],
      error: (e, _) => [ErrorState(message: getErrorMessage(e), onRetry: () => ref.invalidate(dashboardProvider))],
      data: (data) {
        final needsResponse = data.needsResponse;
        final upcoming = data.upcoming.where((b) => !b.needsResponse).toList();
        return [
          if (needsResponse.isNotEmpty) ...[
            const HomeSectionTitle(title: 'Needs your response'),
            bookingList(needsResponse),
            const SizedBox(height: AppSizes.md),
          ],
          if (data.stats.isNotEmpty) ...[
            DashboardStatsRow(stats: data.stats),
            const SizedBox(height: AppSizes.lg),
          ],
          if (data.today.isNotEmpty) ...[
            const HomeSectionTitle(title: 'Today'),
            bookingList(data.today),
            const SizedBox(height: AppSizes.md),
          ],
          HomeSectionTitle(title: 'Upcoming Consultations', onSeeAll: () => _goToTab(ref, 2)),
          if (upcoming.isEmpty && needsResponse.isEmpty)
            const HomeEmptyNote(icon: Icons.event_available_outlined, text: 'No upcoming consultations. Find an advocate below to book one.')
          else
            bookingList(upcoming),
        ];
      },
    );

    return Column(
      children: [
        HomeHeader(
          userName: (user?.name.isNotEmpty ?? false) ? user!.name : 'there',
          avatarUrl: user?.profilePhoto,
          unreadCount: unread,
          onAvatarTap: () => _goToTab(ref, 3),
          onNotificationTap: () async {
            await context.push(RouteNames.notifications);
            ref.read(unreadCountProvider.notifier).refresh();
          },
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refresh(ref),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppSizes.md),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AdvocateSearchCard(onSearch: () => _goToTab(ref, 1)),
                      const SizedBox(height: AppSizes.lg),
                      ...dashboardSections,
                      const SizedBox(height: AppSizes.lg),
                      HomeSectionTitle(title: 'Recommended Advocates', onSeeAll: () => _goToTab(ref, 1)),
                      ...advocates.when(
                        loading: () => [const Padding(padding: EdgeInsets.all(AppSizes.lg), child: CustomLoader())],
                        error: (e, _) => [HomeEmptyNote(icon: Icons.cloud_off_rounded, text: getErrorMessage(e))],
                        data: (list) => list.isEmpty
                            ? [const HomeEmptyNote(icon: Icons.gavel_outlined, text: 'No advocates are available right now.')]
                            : [
                                for (final a in list)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: AppSizes.sm + AppSizes.xs),
                                    child: AdvocateCard(
                                      advocate: a,
                                      onTap: () => context.push(RouteNames.lawyerDetailsPath(a.id), extra: a),
                                    ),
                                  ),
                              ],
                      ),
                      const SizedBox(height: AppSizes.xxl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
