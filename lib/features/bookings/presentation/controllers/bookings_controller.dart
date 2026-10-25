import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../core/state/paged_list_state.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository.dart';

/// GET /bookings, newest first. The Upcoming / Past tabs filter the
/// loaded pages by status.
class BookingsController extends PagedListNotifier<BookingModel> {
  @override
  PagedListState<BookingModel> build() => initialLoad();

  @override
  Future<PaginatedResponse<BookingModel>> fetchPage(int page) =>
      ref.read(bookingRepositoryProvider).fetchBookings(page: page);

  /// Swap in a refreshed copy (after an action on the details screen).
  void upsert(BookingModel booking) {
    if (state.items.any((b) => b.id == booking.id)) {
      replaceWhere((b) => b.id == booking.id, (_) => booking);
    } else {
      state = state.copyWith(items: [booking, ...state.items]);
    }
  }
}

final bookingsControllerProvider =
    NotifierProvider<BookingsController, PagedListState<BookingModel>>(BookingsController.new);
