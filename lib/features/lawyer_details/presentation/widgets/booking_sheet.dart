import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/utility/info_tip_banner.dart';
import '../../../bookings/data/models/booking_model.dart';
import '../../../lawyer_list/data/models/advocate_model.dart';

/// Bottom sheet that collects the case details (10–2000 chars) and books
/// the slot. Pops with the created booking on success.
Future<BookingModel?> showBookingSheet(
  BuildContext context, {
  required AdvocateSummary advocate,
  required AdvocateSlot slot,
  required Future<BookingModel> Function(String caseDetails) onBook,
}) {
  return showModalBottomSheet<BookingModel>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: context.appColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppSizes.radiusLg))),
    builder: (_) => _BookingSheet(advocate: advocate, slot: slot, onBook: onBook),
  );
}

class _BookingSheet extends StatefulWidget {
  final AdvocateSummary advocate;
  final AdvocateSlot slot;
  final Future<BookingModel> Function(String caseDetails) onBook;

  const _BookingSheet({required this.advocate, required this.slot, required this.onBook});

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _caseController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _caseController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final booking = await widget.onBook(_caseController.text.trim());
      if (mounted) Navigator.of(context).pop(booking);
    } catch (e) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _error = getErrorMessage(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final slot = widget.slot;
    final when = slot.startsAt != null
        ? '${DateFormatter.shortDay(slot.startsAt!)} · ${DateFormatter.clock(slot.startTime)}'
            '${slot.endTime.isEmpty ? '' : ' – ${DateFormatter.clock(slot.endTime)}'}'
        : DateFormatter.clock(slot.startTime);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(AppSizes.lg, 0, AppSizes.lg, AppSizes.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Confirm Booking', style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                const SizedBox(height: AppSizes.md),
                Container(
                  padding: const EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  ),
                  child: Column(
                    children: [
                      _row(context, 'Advocate', widget.advocate.name),
                      _row(context, 'When', when),
                      if (slot.sessionType != null) _row(context, 'Session', slot.sessionType!),
                      _row(context, 'Consultation fee', CurrencyFormatter.taka(slot.price), bold: true),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.lg),
                Text('Describe your case *', style: TextStyle(fontWeight: FontWeight.w700, color: colors.textPrimary)),
                const SizedBox(height: AppSizes.sm),
                TextFormField(
                  controller: _caseController,
                  minLines: 4,
                  maxLines: 8,
                  maxLength: 2000,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Briefly explain your legal issue so the advocate can prepare…',
                    filled: true,
                    fillColor: colors.background,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
                  ),
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.length < 10) return 'Please write at least 10 characters.';
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.sm),
                const InfoTipBanner(
                  text: 'The slot is held for 15 minutes after booking. Complete the payment in that time to send the request to the advocate.',
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSizes.md),
                  Text(_error!, style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                ],
                const SizedBox(height: AppSizes.lg),
                PrimaryButton(label: 'Book & Continue to Payment', loading: _submitting, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
        child: Row(
          children: [
            Text(label, style: TextStyle(fontSize: AppSizes.fontSm, color: context.appColors.textSecondary)),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: bold ? AppSizes.fontMd : AppSizes.fontSm,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w600,
                  color: bold ? AppColors.primary : context.appColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      );
}
