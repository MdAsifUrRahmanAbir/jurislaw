import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../lawyer_list/data/models/advocate_model.dart';
import '../states/lawyer_details_state.dart';

/// "Book a Consultation" card — a strip of days that have open slots,
/// then that day's slots as selectable tiles (time, session type, price).
class SlotPicker extends StatelessWidget {
  final LawyerDetailsState state;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String> onSlotSelected;
  final VoidCallback onLoadMore;

  const SlotPicker({
    super.key,
    required this.state,
    required this.onDateSelected,
    required this.onSlotSelected,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final dates = state.slotDates;
    final selectedDay = state.selectedDate ?? (dates.isEmpty ? null : dates.first);
    final daySlots = state.slotsForSelectedDate;

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, color: AppColors.primary),
              const SizedBox(width: AppSizes.sm),
              Text('Book a Consultation', style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: colors.textPrimary)),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          if (state.slots.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
              child: Center(
                child: Text(
                  'No available slots at the moment.\nPlease check back later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.textSecondary, height: 1.5),
                ),
              ),
            )
          else ...[
            SizedBox(
              height: 72,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length + (state.hasMoreSlots ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(width: AppSizes.sm),
                itemBuilder: (context, index) {
                  if (index == dates.length) {
                    return _MoreDatesButton(loading: state.isLoadingMoreSlots, onTap: onLoadMore);
                  }
                  final day = dates[index];
                  return _DateTile(date: day, selected: day == selectedDay, onTap: () => onDateSelected(day));
                },
              ),
            ),
            const SizedBox(height: AppSizes.md),
            if (selectedDay != null)
              Text(
                DateFormat('EEEE, d MMMM').format(selectedDay),
                style: TextStyle(fontSize: AppSizes.fontSm, fontWeight: FontWeight.w600, color: colors.textSecondary),
              ),
            const SizedBox(height: AppSizes.sm),
            LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth > 520 ? 3 : 2;
                final width = (constraints.maxWidth - AppSizes.sm * (columns - 1)) / columns;
                return Wrap(
                  spacing: AppSizes.sm,
                  runSpacing: AppSizes.sm,
                  children: [
                    for (final slot in daySlots)
                      SizedBox(
                        width: width,
                        child: _SlotTile(slot: slot, selected: slot.id == state.selectedSlotId, onTap: () => onSlotSelected(slot.id)),
                      ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  const _DateTile({required this.date, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 60,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : colors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: selected ? AppColors.primary : colors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(DateFormat('EEE').format(date),
                style: TextStyle(fontSize: AppSizes.fontXs, color: selected ? AppColors.textWhite : colors.textSecondary)),
            Text('${date.day}',
                style: TextStyle(fontSize: AppSizes.fontLg, fontWeight: FontWeight.w700, color: selected ? AppColors.textWhite : colors.textPrimary)),
            Text(DateFormat('MMM').format(date),
                style: TextStyle(fontSize: AppSizes.fontXs, color: selected ? AppColors.textWhite : colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _MoreDatesButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _MoreDatesButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: Container(
        width: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('More\ndates', textAlign: TextAlign.center, style: TextStyle(fontSize: AppSizes.fontXs, fontWeight: FontWeight.w600, color: AppColors.primary)),
      ),
    );
  }
}

class _SlotTile extends StatelessWidget {
  final AdvocateSlot slot;
  final bool selected;
  final VoidCallback onTap;

  const _SlotTile({required this.slot, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final time = slot.endTime.isEmpty
        ? DateFormatter.clock(slot.startTime)
        : '${DateFormatter.clock(slot.startTime)} – ${DateFormatter.clock(slot.endTime)}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSizes.sm + AppSizes.xs),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : colors.background,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: selected ? AppColors.primary : colors.border, width: selected ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(time, style: TextStyle(fontSize: AppSizes.fontSm, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                ),
                if (selected) const Icon(Icons.check_circle_rounded, size: AppSizes.iconSm, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: AppSizes.xs),
            if (slot.sessionType != null)
              Text(slot.sessionType!, style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textSecondary)),
            Text(
              CurrencyFormatter.taka(slot.price),
              style: const TextStyle(fontSize: AppSizes.fontSm, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
