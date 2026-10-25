import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../core/widgets/common/initials_avatar.dart';
import '../../data/models/booking_model.dart';
import 'booking_status_badge.dart';

/// Booking card used by the bookings tab and the dashboard. Highlights
/// bookings that need the client to act (pay / answer a reschedule / join).
class BookingListItem extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onTap;

  const BookingListItem({super.key, required this.booking, this.onTap});

  ({String label, IconData icon, Color color})? get _callout {
    if (booking.isPendingPayment) {
      return (label: 'Payment pending — tap to pay', icon: Icons.payment_rounded, color: AppColors.warning);
    }
    if (booking.needsResponse) {
      return (label: 'New time proposed — respond', icon: Icons.event_repeat_rounded, color: AppColors.warning);
    }
    if (booking.canJoinSession) {
      return (label: 'Session is open — join now', icon: Icons.forum_rounded, color: AppColors.success);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final callout = _callout;

    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InitialsAvatar(name: booking.advocate.name, imageUrl: booking.advocate.photoUrl, size: 44),
              const SizedBox(width: AppSizes.sm + AppSizes.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.advocate.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: AppSizes.fontMd, color: colors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    if (booking.startsAt != null)
                      Row(
                        children: [
                          Icon(Icons.schedule_rounded, size: 14, color: colors.textSecondary),
                          const SizedBox(width: AppSizes.xs),
                          Flexible(
                            child: Text(
                              '${DateFormatter.shortDay(booking.startsAt!)}, ${DateFormatter.time(booking.startsAt!)}',
                              style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    if (booking.sessionType != null)
                      Text(booking.sessionType!, style: TextStyle(fontSize: AppSizes.fontXs, color: colors.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BookingStatusBadge(booking: booking),
                  const SizedBox(height: AppSizes.xs),
                  if (booking.amount > 0)
                    Text(CurrencyFormatter.taka(booking.amount), style: TextStyle(fontWeight: FontWeight.w700, color: colors.textPrimary)),
                ],
              ),
            ],
          ),
          if (callout != null) ...[
            const SizedBox(height: AppSizes.sm + AppSizes.xs),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm + AppSizes.xs, vertical: AppSizes.sm),
              decoration: BoxDecoration(
                color: callout.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              child: Row(
                children: [
                  Icon(callout.icon, size: AppSizes.iconSm, color: callout.color),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(child: Text(callout.label, style: TextStyle(fontSize: AppSizes.fontXs, fontWeight: FontWeight.w700, color: callout.color))),
                  Icon(Icons.chevron_right_rounded, size: AppSizes.iconSm, color: callout.color),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
