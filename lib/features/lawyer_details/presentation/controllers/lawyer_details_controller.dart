import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/error_mapper.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../../../bookings/data/repositories/booking_repository.dart';
import '../../../lawyer_list/data/models/advocate_model.dart';
import '../../../lawyer_list/data/repositories/advocate_repository.dart';
import '../states/lawyer_details_state.dart';

/// One advocate's profile (A4.3) with their open slots, paging further
/// slots through A4.4, and booking the chosen slot (A5.3).
class LawyerDetailsController extends Notifier<LawyerDetailsState> {
  LawyerDetailsController(this.advocateId);

  final String advocateId;

  @override
  LawyerDetailsState build() {
    Future.microtask(load);
    return const LawyerDetailsState();
  }

  AdvocateRepository get _repository => ref.read(advocateRepositoryProvider);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final advocate = await _repository.fetchAdvocate(advocateId);
      final slots = advocate.slots.where(_isFuture).toList();
      state = LawyerDetailsState(
        advocate: advocate,
        isLoading: false,
        slots: slots,
        hasMoreSlots: advocate.hasMoreSlots,
        selectedDate: _firstDay(slots),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: getErrorMessage(e));
    }
  }

  /// Pages through GET /advocates/{id}/slots and merges new slots in.
  Future<void> loadMoreSlots() async {
    if (state.isLoadingMoreSlots || !state.hasMoreSlots) return;
    state = state.copyWith(isLoadingMoreSlots: true);
    try {
      final page = state.slotPage + 1;
      final result = await _repository.fetchSlots(advocateId, from: DateTime.now(), page: page);
      final known = state.slots.map((s) => s.id).toSet();
      final merged = [...state.slots, ...result.items.where((s) => !known.contains(s.id) && _isFuture(s))];
      state = state.copyWith(
        slots: merged,
        slotPage: page,
        hasMoreSlots: result.hasMore && result.items.isNotEmpty,
        isLoadingMoreSlots: false,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMoreSlots: false, errorMessage: getErrorMessage(e));
    }
  }

  void selectDate(DateTime date) => state = state.copyWith(selectedDate: date, clearSelectedSlot: true);

  void selectSlot(String slotId) =>
      state = state.selectedSlotId == slotId ? state.copyWith(clearSelectedSlot: true) : state.copyWith(selectedSlotId: slotId);

  /// POST /schedules/{id}/book. Throws [ApiException] so the booking sheet
  /// can show the reason (slot taken, 3 unpaid holds, …). A taken slot is
  /// dropped from the list.
  Future<BookingModel> book(String caseDetails) async {
    final slot = state.selectedSlot;
    if (slot == null) throw StateError('No slot selected');
    try {
      return await ref.read(bookingRepositoryProvider).bookSlot(slot.id, caseDetails: caseDetails);
    } catch (e) {
      if (getErrorMessage(e).toLowerCase().contains('taken')) {
        state = state.copyWith(slots: state.slots.where((s) => s.id != slot.id).toList(), clearSelectedSlot: true);
      }
      rethrow;
    }
  }

  static bool _isFuture(AdvocateSlot slot) {
    final start = slot.startsAt;
    return start == null || start.isAfter(DateTime.now());
  }

  static DateTime? _firstDay(List<AdvocateSlot> slots) {
    final days = [
      for (final s in slots)
        if (s.date != null) DateTime(s.date!.year, s.date!.month, s.date!.day),
    ]..sort();
    return days.isEmpty ? null : days.first;
  }
}

final lawyerDetailsControllerProvider =
    NotifierProvider.autoDispose.family<LawyerDetailsController, LawyerDetailsState, String>(LawyerDetailsController.new);
