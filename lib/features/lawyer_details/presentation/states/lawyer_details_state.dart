import '../../../lawyer_list/data/models/advocate_model.dart';

class LawyerDetailsState {
  final AdvocateDetail? advocate;
  final bool isLoading;
  final String? errorMessage;
  final List<AdvocateSlot> slots;
  final bool hasMoreSlots;
  final int slotPage;
  final bool isLoadingMoreSlots;
  final DateTime? selectedDate;
  final String? selectedSlotId;

  const LawyerDetailsState({
    this.advocate,
    this.isLoading = true,
    this.errorMessage,
    this.slots = const [],
    this.hasMoreSlots = false,
    this.slotPage = 0,
    this.isLoadingMoreSlots = false,
    this.selectedDate,
    this.selectedSlotId,
  });

  /// Distinct slot days, soonest first.
  List<DateTime> get slotDates {
    final days = <DateTime>{
      for (final s in slots)
        if (s.date != null) DateTime(s.date!.year, s.date!.month, s.date!.day),
    }.toList()
      ..sort();
    return days;
  }

  List<AdvocateSlot> get slotsForSelectedDate {
    final day = selectedDate ?? (slotDates.isEmpty ? null : slotDates.first);
    if (day == null) return slots;
    return slots
        .where((s) => s.date != null && s.date!.year == day.year && s.date!.month == day.month && s.date!.day == day.day)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  AdvocateSlot? get selectedSlot {
    final match = slots.where((s) => s.id == selectedSlotId);
    return match.isEmpty ? null : match.first;
  }

  LawyerDetailsState copyWith({
    AdvocateDetail? advocate,
    bool? isLoading,
    String? errorMessage,
    List<AdvocateSlot>? slots,
    bool? hasMoreSlots,
    int? slotPage,
    bool? isLoadingMoreSlots,
    DateTime? selectedDate,
    String? selectedSlotId,
    bool clearSelectedSlot = false,
  }) {
    return LawyerDetailsState(
      advocate: advocate ?? this.advocate,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      slots: slots ?? this.slots,
      hasMoreSlots: hasMoreSlots ?? this.hasMoreSlots,
      slotPage: slotPage ?? this.slotPage,
      isLoadingMoreSlots: isLoadingMoreSlots ?? this.isLoadingMoreSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlotId: clearSelectedSlot ? null : (selectedSlotId ?? this.selectedSlotId),
    );
  }
}
