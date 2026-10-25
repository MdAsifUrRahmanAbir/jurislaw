import 'dart:async';

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
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/common/secondary_button.dart';
import '../../../../core/widgets/utility/custom_loader.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../../../../core/widgets/utility/error_state.dart';
import '../../../../routes/route_names.dart';
import '../../data/models/payment_models.dart';
import '../../data/repositories/payment_repository.dart';
import '../controllers/checkout_controller.dart';
import 'payment_gateway_screen.dart';

/// Checkout (A6.1): fee breakdown, the 15-minute hold countdown, and
/// "Pay" which opens SSLCommerz (A6.2) and then polls the result (A6.3).
class CheckoutScreen extends ConsumerWidget {
  final String bookingId;

  const CheckoutScreen({super.key, required this.bookingId});

  Future<void> _pay(BuildContext context, WidgetRef ref) async {
    final session = await ref.read(checkoutControllerProvider(bookingId).notifier).startPayment();
    if (session == null || !context.mounted) return;
    final returned = await context.push<bool>(
      RouteNames.paymentGateway,
      extra: PaymentGatewayArgs(session: session, bookingId: bookingId),
    );
    if (!context.mounted || session.transactionId.isEmpty) return;
    if (returned != true) {
      // Backed out of the gateway — only move on if it was actually paid.
      final paid = await ref
          .read(paymentRepositoryProvider)
          .fetchStatus(session.transactionId)
          .then((s) => s.isPaid, onError: (_) => false);
      if (!context.mounted) return;
      if (!paid) {
        CustomSnackbar.show(context, 'Payment was not completed. You can try again while the slot is held.');
        return;
      }
    }
    // The gateway's notification can arrive after the web view closes,
    // so confirm the result on the status screen.
    context.pushReplacement(RouteNames.paymentStatusPath(session.transactionId, bookingId: bookingId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutControllerProvider(bookingId));
    final controller = ref.read(checkoutControllerProvider(bookingId).notifier);

    ref.listen(checkoutControllerProvider(bookingId), (previous, next) {
      if (next.summary != null && next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        CustomSnackbar.show(context, next.errorMessage!, error: true);
      }
    });

    Widget body;
    if (state.isLoading && state.summary == null) {
      body = const CustomLoader(label: 'Preparing checkout…');
    } else if (state.summary == null) {
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ErrorState(message: state.errorMessage ?? 'Could not load checkout.', onRetry: controller.load),
          TextButton(
            onPressed: () => context.pushReplacement(RouteNames.bookingDetailsPath(bookingId)),
            child: const Text('View booking'),
          ),
        ],
      );
    } else {
      body = _CheckoutBody(
        summary: state.summary!,
        isStartingPayment: state.isStartingPayment,
        onPay: () => _pay(context, ref),
        onViewBooking: () => context.pushReplacement(RouteNames.bookingDetailsPath(bookingId)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Checkout'),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _CheckoutBody extends StatelessWidget {
  final CheckoutSummary summary;
  final bool isStartingPayment;
  final VoidCallback onPay;
  final VoidCallback onViewBooking;

  const _CheckoutBody({required this.summary, required this.isStartingPayment, required this.onPay, required this.onViewBooking});

  Widget _line(BuildContext context, String label, double amount, {bool total = false}) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs + 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: total ? AppSizes.fontMd : AppSizes.fontSm,
                fontWeight: total ? FontWeight.w700 : FontWeight.w500,
                color: total ? colors.textPrimary : colors.textSecondary,
              )),
          Text(CurrencyFormatter.taka(amount),
              style: TextStyle(
                fontSize: total ? AppSizes.fontXl : AppSizes.fontSm,
                fontWeight: FontWeight.w700,
                color: total ? AppColors.primary : colors.textPrimary,
              )),
        ],
      ),
    );
  }

  String _labelFor(String key) {
    final text = key.replaceAll('_', ' ');
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (summary.reservedUntil != null) _HoldCountdown(until: summary.reservedUntil!),
              const SizedBox(height: AppSizes.md),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Consultation', style: TextStyle(fontSize: AppSizes.fontXs, fontWeight: FontWeight.w700, letterSpacing: 1.1, color: colors.textSecondary)),
                    const SizedBox(height: AppSizes.sm),
                    if (summary.advocateName.isNotEmpty)
                      Text(summary.advocateName, style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                    if (summary.startsAt != null) ...[
                      const SizedBox(height: AppSizes.xs),
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: AppSizes.iconSm, color: colors.textSecondary),
                          const SizedBox(width: AppSizes.xs),
                          Text(
                            '${DateFormatter.shortDay(summary.startsAt!)}, ${DateFormatter.time(summary.startsAt!)}'
                            '${summary.endsAt != null ? ' – ${DateFormatter.time(summary.endsAt!)}' : ''}',
                            style: TextStyle(fontSize: AppSizes.fontSm, color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                    if (summary.sessionType != null) ...[
                      const SizedBox(height: AppSizes.xs),
                      Text(summary.sessionType!, style: TextStyle(fontSize: AppSizes.fontSm, color: colors.textSecondary)),
                    ],
                    Text('Booking #${summary.bookingId}', style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textHint)),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),
              CustomCard(
                child: Column(
                  children: [
                    _line(context, 'Advocate fee', summary.advocateFee),
                    _line(context, 'Platform charge', summary.platformCharge),
                    for (final extra in summary.extraLines) _line(context, _labelFor(extra.key), extra.value),
                    Divider(color: colors.divider, height: AppSizes.lg),
                    _line(context, 'Total payable', summary.total, total: true),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Icon(Icons.lock_outline_rounded, size: AppSizes.iconSm, color: colors.textSecondary),
                  const SizedBox(width: AppSizes.xs),
                  Expanded(
                    child: Text(
                      'You will pay securely on SSLCommerz (bKash, Nagad, cards & more). The advocate is notified once the payment is confirmed.',
                      style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              if (!summary.gatewayAvailable)
                Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: const Text(
                    'Online payment is currently unavailable. Please try again later — your booking stays reserved until the hold expires.',
                    style: TextStyle(color: AppColors.warning, fontWeight: FontWeight.w600),
                  ),
                )
              else
                PrimaryButton(
                  label: 'Pay ${CurrencyFormatter.taka(summary.total)}',
                  icon: Icons.payment_rounded,
                  loading: isStartingPayment,
                  onPressed: onPay,
                ),
              const SizedBox(height: AppSizes.sm),
              SecondaryButton(label: 'Pay later — view booking', onPressed: onViewBooking),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Slot held for 12:34" — the 15-minute reservation from A5.3.
class _HoldCountdown extends StatefulWidget {
  final DateTime until;

  const _HoldCountdown({required this.until});

  @override
  State<_HoldCountdown> createState() => _HoldCountdownState();
}

class _HoldCountdownState extends State<_HoldCountdown> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final left = widget.until.difference(DateTime.now());
    final expired = left.isNegative;
    final color = expired ? AppColors.error : (left.inMinutes < 3 ? AppColors.warning : AppColors.info);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + AppSizes.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(expired ? Icons.timer_off_outlined : Icons.timer_outlined, color: color),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              expired ? 'The slot hold has expired. The slot may no longer be available.' : 'Slot held for you — complete payment in',
              style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: AppSizes.fontSm),
            ),
          ),
          if (!expired)
            Text(DateFormatter.countdown(left),
                style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: AppSizes.fontLg, fontFeatures: const [FontFeature.tabularFigures()])),
        ],
      ),
    );
  }
}
