import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/error_mapper.dart';
import '../../../home/presentation/controllers/home_controller.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository.dart';
import 'bookings_controller.dart';

class BookingDetailsState {
  final BookingModel? booking;
  final bool isLoading;
  final bool isActing;
  final String? errorMessage;

  const BookingDetailsState({this.booking, this.isLoading = true, this.isActing = false, this.errorMessage});

  BookingDetailsState copyWith({BookingModel? booking, bool? isLoading, bool? isActing, String? errorMessage}) {
    return BookingDetailsState(
      booking: booking ?? this.booking,
      isLoading: isLoading ?? this.isLoading,
      isActing: isActing ?? this.isActing,
      errorMessage: errorMessage,
    );
  }
}

/// One booking (A5.2) and the client's actions on it: accept / decline a
/// reschedule (A5.4 / A5.5) and cancel with refund (A5.6).
class BookingDetailsController extends Notifier<BookingDetailsState> {
  BookingDetailsController(this.bookingId);

  final String bookingId;

  @override
  BookingDetailsState build() {
    Future.microtask(load);
    return const BookingDetailsState();
  }

  BookingRepository get _repository => ref.read(bookingRepositoryProvider);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final booking = await _repository.fetchBooking(bookingId);
      state = BookingDetailsState(booking: booking, isLoading: false);
      ref.read(bookingsControllerProvider.notifier).upsert(booking);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: getErrorMessage(e));
    }
  }

  /// Runs an action, then reloads the booking and the lists behind it.
  /// Returns the server message on success, null on failure (error in state).
  Future<String?> _act(Future<String?> Function() action, String fallbackMessage) async {
    if (state.isActing) return null;
    state = state.copyWith(isActing: true, errorMessage: null);
    try {
      final message = await action();
      state = state.copyWith(isActing: false);
      await load();
      ref.invalidate(dashboardProvider);
      return message ?? fallbackMessage;
    } catch (e) {
      state = state.copyWith(isActing: false, errorMessage: getErrorMessage(e));
      return null;
    }
  }

  Future<String?> acceptReschedule() =>
      _act(() => _repository.acceptReschedule(bookingId), 'New time accepted.');

  Future<String?> declineReschedule({String? requestedScheduleId}) => _act(
        () => _repository.declineReschedule(bookingId, requestedScheduleId: requestedScheduleId),
        'Proposal declined.',
      );

  Future<String?> cancel(String reason) =>
      _act(() => _repository.cancelBooking(bookingId, reason: reason), 'Booking cancelled. Your refund is being processed.');
}

final bookingDetailsControllerProvider =
    NotifierProvider.autoDispose.family<BookingDetailsController, BookingDetailsState, String>(BookingDetailsController.new);
