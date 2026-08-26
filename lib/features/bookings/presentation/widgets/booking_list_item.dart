import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../core/widgets/common/status_badge.dart';
import '../../data/models/booking_model.dart';

class BookingListItem extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback? onTap;

  const BookingListItem({super.key, required this.booking, this.onTap});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isUpcoming = booking.status == BookingStatus.upcoming;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: CustomCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: AppSizes.xxl,
              height: AppSizes.xxl,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.personName,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: AppSizes.fontMd, color: context.appColors.textPrimary),
                  ),
                  const SizedBox(height: AppSizes.xs / 2),
                  Text(
                    _formatDate(booking.dateTime),
                    style: TextStyle(fontSize: AppSizes.fontXs, color: context.appColors.textSecondary),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  StatusBadge(
                    text: isUpcoming ? 'Upcoming' : 'Completed',
                    type: isUpcoming ? StatusBadgeType.success : StatusBadgeType.neutral,
                    compact: true,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: AppSizes.iconSm, color: context.appColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
