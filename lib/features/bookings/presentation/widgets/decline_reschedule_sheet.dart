import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/common/secondary_button.dart';
import '../../../../core/widgets/utility/custom_loader.dart';
import '../../../lawyer_list/data/models/advocate_model.dart';
import '../../../lawyer_list/data/repositories/advocate_repository.dart';
import '../../data/models/booking_model.dart';

/// Result of the decline sheet: `requestedScheduleId` is the optional
/// counter-offer (one of the same advocate's open slots).
class DeclineChoice {
  final String? requestedScheduleId;
  const DeclineChoice(this.requestedScheduleId);
}

Future<DeclineChoice?> showDeclineRescheduleSheet(BuildContext context, BookingModel booking) {
  return showModalBottomSheet<DeclineChoice>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: context.appColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg))),
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      builder: (context, scrollController) => _DeclineSheet(booking: booking, scrollController: scrollController),
    ),
  );
}

class _DeclineSheet extends ConsumerStatefulWidget {
  final BookingModel booking;
  final ScrollController scrollController;

  const _DeclineSheet({required this.booking, required this.scrollController});

  @override
  ConsumerState<_DeclineSheet> createState() => _DeclineSheetState();
}

class _DeclineSheetState extends ConsumerState<_DeclineSheet> {
  List<AdvocateSlot>? _slots;
  String? _error;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.booking.advocate.id.isEmpty) {
      setState(() => _slots = const []);
      return;
    }
    try {
      final result = await ref.read(advocateRepositoryProvider).fetchSlots(widget.booking.advocate.id, from: DateTime.now());
      final declined = widget.booking.declinedSlotIds.toSet();
      if (mounted) setState(() => _slots = result.items.where((s) => !declined.contains(s.id)).toList());
    } catch (e) {
      if (mounted) setState(() => _error = getErrorMessage(e));
    }
  }

  Widget _slotTile(AdvocateSlot slot, AppColorScheme colors) => RadioListTile<String>(
        value: slot.id,
        toggleable: true,
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
        title: Text(
          slot.startsAt != null
              ? '${DateFormatter.shortDay(slot.startsAt!)}, ${DateFormatter.clock(slot.startTime)}'
              : DateFormatter.clock(slot.startTime),
          style: TextStyle(fontWeight: FontWeight.w600, color: colors.textPrimary),
        ),
        subtitle: Text([if (slot.sessionType != null) slot.sessionType!, CurrencyFormatter.taka(slot.price)].join(' · ')),
      );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.md),
            children: [
              Text('Decline new time', style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700, color: colors.textPrimary)),
              const SizedBox(height: AppSizes.sm),
              Text(
                'Optionally pick another of ${widget.booking.advocate.name}\'s open slots to request instead. '
                'The decline always stands — only the requested time can fail.',
                style: TextStyle(color: colors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: AppSizes.md),
              if (_error != null)
                Text(_error!, style: const TextStyle(color: AppColors.error))
              else if (_slots == null)
                const Padding(padding: EdgeInsets.all(AppSizes.xl), child: CustomLoader())
              else if (_slots!.isEmpty)
                Text('No other open slots right now.', style: TextStyle(color: colors.textSecondary))
              else
                RadioGroup<String>(
                  groupValue: _selected,
                  onChanged: (value) => setState(() => _selected = value),
                  child: Column(
                    children: [
                      for (final slot in _slots!) _slotTile(slot, colors),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.md),
            child: Column(
              children: [
                PrimaryButton(
                  label: _selected == null ? 'Decline' : 'Decline & request this time',
                  onPressed: () => Navigator.of(context).pop(DeclineChoice(_selected)),
                ),
                const SizedBox(height: AppSizes.sm),
                SecondaryButton(label: 'Keep deciding', onPressed: () => Navigator.of(context).pop()),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
