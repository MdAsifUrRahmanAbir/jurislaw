import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/utility/custom_loader.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../../../../core/widgets/utility/error_state.dart';
import '../../../../routes/route_names.dart';
import '../../../lawyer_list/data/models/advocate_model.dart';
import '../controllers/lawyer_details_controller.dart';
import '../widgets/advocate_profile_section.dart';
import '../widgets/booking_sheet.dart';
import '../widgets/slot_picker.dart';

/// Advocate profile (A4.3) with open slots; picking a slot and entering
/// the case details books it (A5.3) and goes straight to checkout (A6).
class LawyerDetailsScreen extends ConsumerWidget {
  final String advocateId;

  /// The directory row, shown while the full profile loads.
  final AdvocateSummary? preview;

  const LawyerDetailsScreen({super.key, required this.advocateId, this.preview});

  Future<void> _book(BuildContext context, WidgetRef ref) async {
    final state = ref.read(lawyerDetailsControllerProvider(advocateId));
    final slot = state.selectedSlot;
    final advocate = state.advocate;
    if (slot == null || advocate == null) return;

    final booking = await showBookingSheet(
      context,
      advocate: advocate,
      slot: slot,
      onBook: ref.read(lawyerDetailsControllerProvider(advocateId).notifier).book,
    );
    if (booking == null || !context.mounted) return;
    CustomSnackbar.show(context, 'Slot reserved for 15 minutes. Complete the payment to confirm.');
    context.pushReplacement(RouteNames.checkoutPath(booking.id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(lawyerDetailsControllerProvider(advocateId));
    final controller = ref.read(lawyerDetailsControllerProvider(advocateId).notifier);
    final advocate = state.advocate ?? preview;
    final selected = state.selectedSlot;

    ref.listen(lawyerDetailsControllerProvider(advocateId), (previous, next) {
      // Errors while paging slots — the profile itself is still on screen.
      if (next.advocate != null && next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        CustomSnackbar.show(context, next.errorMessage!, error: true);
      }
    });

    Widget body;
    if (state.isLoading && advocate == null) {
      body = const CustomLoader();
    } else if (state.advocate == null && state.errorMessage != null) {
      body = ErrorState(message: state.errorMessage!, onRetry: controller.load);
    } else {
      body = RefreshIndicator(
        onRefresh: controller.load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdvocateProfileSection(advocate: advocate!),
                  const SizedBox(height: AppSizes.md),
                  if (state.advocate == null)
                    const Padding(padding: EdgeInsets.all(AppSizes.xl), child: CustomLoader())
                  else
                    SlotPicker(
                      state: state,
                      onDateSelected: controller.selectDate,
                      onSlotSelected: controller.selectSlot,
                      onLoadMore: controller.loadMoreSlots,
                    ),
                  const SizedBox(height: AppSizes.xxl * 2),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Advocate Profile'),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: selected == null
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(AppSizes.md, AppSizes.sm + AppSizes.xs, AppSizes.md, AppSizes.sm + AppSizes.xs),
              decoration: BoxDecoration(
                color: context.appColors.surface,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: AppSizes.md, offset: const Offset(0, -4))],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selected.startsAt != null
                                ? '${DateFormatter.shortDay(selected.startsAt!)}, ${DateFormatter.clock(selected.startTime)}'
                                : DateFormatter.clock(selected.startTime),
                            style: TextStyle(fontSize: AppSizes.fontSm, color: context.appColors.textSecondary),
                          ),
                          Text(
                            CurrencyFormatter.taka(selected.price),
                            style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    PrimaryButton(label: 'Book Now', width: 150, onPressed: () => _book(context, ref)),
                  ],
                ),
              ),
            ),
    );
  }
}
