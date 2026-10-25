import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/error_mapper.dart';
import '../../data/models/payment_models.dart';
import '../../data/repositories/payment_repository.dart';

class CheckoutState {
  final CheckoutSummary? summary;
  final bool isLoading;
  final bool isStartingPayment;
  final String? errorMessage;

  const CheckoutState({this.summary, this.isLoading = true, this.isStartingPayment = false, this.errorMessage});

  CheckoutState copyWith({CheckoutSummary? summary, bool? isLoading, bool? isStartingPayment, String? errorMessage}) {
    return CheckoutState(
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      isStartingPayment: isStartingPayment ?? this.isStartingPayment,
      errorMessage: errorMessage,
    );
  }
}

/// A6.1 checkout summary → A6.2 start payment for one booking.
class CheckoutController extends Notifier<CheckoutState> {
  CheckoutController(this.bookingId);

  final String bookingId;

  @override
  CheckoutState build() {
    Future.microtask(load);
    return const CheckoutState();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final summary = await ref.read(paymentRepositoryProvider).fetchCheckout(bookingId);
      state = CheckoutState(summary: summary, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: getErrorMessage(e));
    }
  }

  /// Returns the gateway session to open, or null (error in state).
  Future<PaymentSession?> startPayment() async {
    if (state.isStartingPayment) return null;
    state = state.copyWith(isStartingPayment: true, errorMessage: null);
    try {
      final session = await ref.read(paymentRepositoryProvider).startPayment(bookingId);
      state = state.copyWith(isStartingPayment: false);
      if (session.gatewayUrl.isEmpty) {
        state = state.copyWith(errorMessage: 'The payment page could not be opened. Please try again.');
        return null;
      }
      return session;
    } catch (e) {
      state = state.copyWith(isStartingPayment: false, errorMessage: getErrorMessage(e));
      return null;
    }
  }
}

final checkoutControllerProvider =
    NotifierProvider.autoDispose.family<CheckoutController, CheckoutState, String>(CheckoutController.new);
