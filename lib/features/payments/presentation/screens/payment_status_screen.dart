import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/common/secondary_button.dart';
import '../../../../routes/route_names.dart';
import '../../../bookings/presentation/controllers/bookings_controller.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../data/models/payment_models.dart';
import '../../data/repositories/payment_repository.dart';

/// Polls GET /payments/{transaction_id} (A6.3) while `is_pending` — the
/// gateway's notification can arrive after the web view closes.
class PaymentStatusScreen extends ConsumerStatefulWidget {
  final String transactionId;
  final String? bookingId;

  const PaymentStatusScreen({super.key, required this.transactionId, this.bookingId});

  @override
  ConsumerState<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends ConsumerState<PaymentStatusScreen> {
  static const _pollEvery = Duration(seconds: 3);
  static const _giveUpAfter = Duration(minutes: 2);

  Timer? _timer;
  PaymentStatus? _status;
  String? _error;
  late DateTime _startedAt;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _startedAt = DateTime.now();
    _error = null;
    _poll();
  }

  Future<void> _poll() async {
    _timer?.cancel();
    try {
      final status = await ref.read(paymentRepositoryProvider).fetchStatus(widget.transactionId);
      if (!mounted) return;
      setState(() {
        _status = status;
        _error = null;
      });
      if (!status.isPending) {
        // Booking moved to pending_advocate — refresh the lists behind us.
        ref.invalidate(bookingsControllerProvider);
        ref.invalidate(dashboardProvider);
        return;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = getErrorMessage(e));
    }
    if (DateTime.now().difference(_startedAt) < _giveUpAfter) {
      _timer = Timer(_pollEvery, _poll);
    } else {
      setState(() {});
    }
  }

  bool get _timedOut => DateTime.now().difference(_startedAt) >= _giveUpAfter;

  String? get _bookingId => _status?.bookingId ?? widget.bookingId;

  void _goHome() => context.go(RouteNames.mainShell);

  @override
  Widget build(BuildContext context) {
    final status = _status;
    final colors = context.appColors;

    late final IconData icon;
    late final Color color;
    late final String title;
    late final String message;
    final actions = <Widget>[];

    if (status != null && status.isPaid) {
      icon = Icons.check_circle_rounded;
      color = AppColors.success;
      title = 'Payment successful';
      message = 'Your request has been sent to the advocate. You will be notified when they accept it.';
      if (_bookingId != null) {
        actions.add(PrimaryButton(label: 'View booking', onPressed: () => context.go(RouteNames.bookingDetailsPath(_bookingId!))));
      }
      actions.add(SecondaryButton(label: 'Back to home', onPressed: _goHome));
    } else if (status != null && status.isFailed) {
      icon = Icons.cancel_rounded;
      color = AppColors.error;
      title = status.status == 'cancelled' ? 'Payment cancelled' : 'Payment failed';
      message = 'No money was taken. You can try again while the slot is still held.';
      if (_bookingId != null) {
        actions.add(PrimaryButton(label: 'Try again', onPressed: () => context.pushReplacement(RouteNames.checkoutPath(_bookingId!))));
      }
      actions.add(SecondaryButton(label: 'Back to home', onPressed: _goHome));
    } else if (_timedOut) {
      icon = Icons.hourglass_bottom_rounded;
      color = AppColors.warning;
      title = 'Still confirming…';
      message = 'The payment is still being confirmed by the gateway. This can take a few minutes — check your bookings shortly.';
      actions.add(PrimaryButton(label: 'Check again', onPressed: () => setState(_startPolling)));
      actions.add(SecondaryButton(label: 'Back to home', onPressed: _goHome));
    } else {
      icon = Icons.sync_rounded;
      color = AppColors.info;
      title = 'Confirming your payment…';
      message = _error ?? 'Please wait while we confirm the payment with the gateway.';
    }

    final pending = status == null || (status.isPending && !_timedOut);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: pending
                          ? Padding(padding: const EdgeInsets.all(28), child: CircularProgressIndicator(color: color, strokeWidth: 3))
                          : Icon(icon, size: 56, color: color),
                    ),
                    const SizedBox(height: AppSizes.lg),
                    Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: AppSizes.fontXxl, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                    const SizedBox(height: AppSizes.sm),
                    Text(message, textAlign: TextAlign.center, style: TextStyle(color: colors.textSecondary, height: 1.5)),
                    if (status?.total != null) ...[
                      const SizedBox(height: AppSizes.md),
                      Text(CurrencyFormatter.taka(status!.total!), style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                    ],
                    const SizedBox(height: AppSizes.xs),
                    Text('Transaction ${widget.transactionId}', style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textHint)),
                    const SizedBox(height: AppSizes.xl),
                    for (final action in actions) ...[action, const SizedBox(height: AppSizes.sm)],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
