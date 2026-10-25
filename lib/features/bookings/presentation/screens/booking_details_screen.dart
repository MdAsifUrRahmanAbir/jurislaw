import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../core/widgets/common/initials_avatar.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/common/secondary_button.dart';
import '../../../../core/widgets/utility/custom_alert_dialog.dart';
import '../../../../core/widgets/utility/custom_loader.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../../../../core/widgets/utility/error_state.dart';
import '../../../../routes/route_names.dart';
import '../../data/models/booking_model.dart';
import '../controllers/booking_details_controller.dart';
import '../widgets/booking_status_badge.dart';
import '../widgets/cancel_booking_dialog.dart';
import '../widgets/decline_reschedule_sheet.dart';

/// One booking (A5.2) with the actions its status allows.
class BookingDetailsScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = bookingDetailsControllerProvider(bookingId);
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    ref.listen(provider, (previous, next) {
      if (next.booking != null && next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        CustomSnackbar.show(context, next.errorMessage!, error: true);
      }
    });

    Widget body;
    if (state.isLoading && state.booking == null) {
      body = const CustomLoader();
    } else if (state.booking == null) {
      body = ErrorState(message: state.errorMessage ?? 'Could not load this booking.', onRetry: controller.load);
    } else {
      body = RefreshIndicator(
        onRefresh: controller.load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSizes.md),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: _BookingDetailsBody(booking: state.booking!, isActing: state.isActing, controller: controller),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Booking Details'),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _BookingDetailsBody extends StatelessWidget {
  final BookingModel booking;
  final bool isActing;
  final BookingDetailsController controller;

  const _BookingDetailsBody({required this.booking, required this.isActing, required this.controller});

  String _range(DateTime start, DateTime? end) =>
      '${DateFormatter.shortDay(start)}, ${DateFormatter.time(start)}${end != null ? ' – ${DateFormatter.time(end)}' : ''}';

  Future<void> _accept(BuildContext context) async {
    final message = await controller.acceptReschedule();
    if (message != null && context.mounted) CustomSnackbar.show(context, message);
  }

  Future<void> _decline(BuildContext context) async {
    final choice = await showDeclineRescheduleSheet(context, booking);
    if (choice == null) return;
    final message = await controller.declineReschedule(requestedScheduleId: choice.requestedScheduleId);
    if (message != null && context.mounted) CustomSnackbar.show(context, message);
  }

  Future<void> _cancel(BuildContext context) async {
    final reason = await showCancelBookingDialog(context);
    if (reason == null) return;
    final message = await controller.cancel(reason);
    if (message != null && context.mounted) CustomSnackbar.show(context, message);
  }

  Future<void> _showCancelBlocked(BuildContext context) => CustomAlertDialog.confirm(
        context,
        title: 'Cannot cancel',
        message: booking.cancelBlocked ?? 'This booking can no longer be cancelled.',
        confirmText: 'OK',
      );

  Widget _infoRow(BuildContext context, IconData icon, String label, String value, {Color? valueColor}) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconSm + 2, color: colors.textSecondary),
          const SizedBox(width: AppSizes.sm + AppSizes.xs),
          SizedBox(width: 110, child: Text(label, style: TextStyle(fontSize: AppSizes.fontSm, color: colors.textSecondary))),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: AppSizes.fontSm, fontWeight: FontWeight.w600, color: valueColor ?? colors.textPrimary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final actions = <Widget>[];

    if (booking.isPendingPayment) {
      actions.add(PrimaryButton(
        label: 'Pay ${booking.amount > 0 ? CurrencyFormatter.taka(booking.amount) : 'now'}',
        icon: Icons.payment_rounded,
        onPressed: () => context.push(RouteNames.checkoutPath(booking.id)),
      ));
    }
    if (booking.isRescheduleOffered) {
      actions.add(PrimaryButton(label: 'Accept new time', loading: isActing, onPressed: () => _accept(context)));
      actions.add(SecondaryButton(label: 'Decline', onPressed: isActing ? null : () => _decline(context)));
    }
    if (booking.hasSessionRoom) {
      final label = booking.canJoinSession ? 'Join Session' : (booking.isConfirmed ? 'Open Session Room' : 'View Chat History');
      final button = booking.canJoinSession
          ? PrimaryButton(label: label, icon: Icons.forum_rounded, onPressed: () => context.push(RouteNames.sessionRoomPath(booking.id)))
          : SecondaryButton(label: label, icon: Icons.forum_outlined, onPressed: () => context.push(RouteNames.sessionRoomPath(booking.id)));
      actions.add(button);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomCard(
          child: Row(
            children: [
              InitialsAvatar(name: booking.advocate.name, imageUrl: booking.advocate.photoUrl, size: 56),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.advocate.name, style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                    const SizedBox(height: AppSizes.xs),
                    BookingStatusBadge(booking: booking),
                  ],
                ),
              ),
              if (booking.advocate.id.isNotEmpty)
                IconButton(
                  tooltip: 'View profile',
                  icon: const Icon(Icons.person_search_outlined),
                  onPressed: () => context.push(RouteNames.lawyerDetailsPath(booking.advocate.id)),
                ),
            ],
          ),
        ),
        if (booking.isRescheduleOffered && booking.proposedAt != null) ...[
          const SizedBox(height: AppSizes.md),
          _Callout(
            color: AppColors.warning,
            icon: Icons.event_repeat_rounded,
            title: 'The advocate proposed a new time',
            message: '${_range(booking.proposedAt!, booking.proposedEndsAt)}\nAccept it, or decline and optionally request another slot.',
          ),
        ],
        if (booking.isPendingPayment && booking.reservedUntil != null) ...[
          const SizedBox(height: AppSizes.md),
          _Callout(
            color: AppColors.warning,
            icon: Icons.timer_outlined,
            title: 'Awaiting payment',
            message: 'Slot held until ${DateFormatter.time(booking.reservedUntil!)}. Pay before then to send the request to the advocate.',
          ),
        ],
        if (booking.status == BookingStatus.pendingAdvocate) ...[
          const SizedBox(height: AppSizes.md),
          const _Callout(
            color: AppColors.info,
            icon: Icons.hourglass_top_rounded,
            title: 'Waiting for the advocate',
            message: 'Your payment is confirmed. You will be notified when the advocate accepts or proposes another time.',
          ),
        ],
        if (booking.clientRequest?.startsAt != null) ...[
          const SizedBox(height: AppSizes.md),
          _Callout(
            color: AppColors.info,
            icon: Icons.send_time_extension_outlined,
            title: 'You requested another time',
            message: '${DateFormatter.dayTime(booking.clientRequest!.startsAt!)} — waiting for the advocate to answer.',
          ),
        ],
        if (booking.refund != null) ...[
          const SizedBox(height: AppSizes.md),
          _Callout(
            color: booking.refund!.isPending ? AppColors.info : AppColors.success,
            icon: Icons.currency_exchange_rounded,
            title: 'Refund ${booking.refund!.status}',
            message: [
              if (booking.refund!.amount != null) 'Amount: ${CurrencyFormatter.taka(booking.refund!.amount!)}',
              booking.refund!.note ?? (booking.refund!.isPending ? 'Refunds are settled by our team, usually within a few working days.' : ''),
            ].where((e) => e.isNotEmpty).join('\n'),
          ),
        ],
        const SizedBox(height: AppSizes.md),
        CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (booking.startsAt != null) _infoRow(context, Icons.event_rounded, 'Date & time', _range(booking.startsAt!, booking.endsAt)),
              if (booking.sessionType != null) _infoRow(context, Icons.videocam_outlined, 'Session', booking.sessionType!),
              if (booking.amount > 0) _infoRow(context, Icons.payments_outlined, 'Amount', CurrencyFormatter.taka(booking.amount)),
              if (booking.paymentStatus.isNotEmpty)
                _infoRow(
                  context,
                  Icons.receipt_outlined,
                  'Payment',
                  booking.paymentStatus[0].toUpperCase() + booking.paymentStatus.substring(1).replaceAll('_', ' '),
                  valueColor: booking.isPaid ? AppColors.success : null,
                ),
              _infoRow(context, Icons.tag_rounded, 'Booking ID', '#${booking.id}'),
              if (booking.createdAt != null) _infoRow(context, Icons.history_rounded, 'Booked on', DateFormatter.dayTime(booking.createdAt!)),
              if (booking.cancellationReason != null) _infoRow(context, Icons.cancel_outlined, 'Cancel reason', booking.cancellationReason!),
            ],
          ),
        ),
        if (booking.caseDetails != null) ...[
          const SizedBox(height: AppSizes.md),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CASE DETAILS', style: TextStyle(fontSize: AppSizes.fontXs, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: colors.textSecondary)),
                const SizedBox(height: AppSizes.sm),
                Text(booking.caseDetails!, style: TextStyle(height: 1.5, color: colors.textPrimary)),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSizes.lg),
        for (final action in actions) ...[action, const SizedBox(height: AppSizes.sm)],
        if (booking.canCancel)
          TextButton.icon(
            onPressed: isActing ? null : () => _cancel(context),
            icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
            label: const Text('Cancel & request refund', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
          )
        else if (booking.cancelBlocked != null && !booking.isFinished)
          TextButton.icon(
            onPressed: () => _showCancelBlocked(context),
            icon: Icon(Icons.info_outline_rounded, color: colors.textSecondary),
            label: Text('Why can\'t I cancel?', style: TextStyle(color: colors.textSecondary)),
          ),
        const SizedBox(height: AppSizes.xl),
      ],
    );
  }
}

class _Callout extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String message;

  const _Callout({required this.color, required this.icon, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSizes.sm + AppSizes.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
                if (message.isNotEmpty) ...[
                  const SizedBox(height: AppSizes.xs),
                  Text(message, style: TextStyle(fontSize: AppSizes.fontSm, height: 1.4, color: context.appColors.textPrimary)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
