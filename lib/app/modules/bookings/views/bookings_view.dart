import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: const Text('My Bookings', style: TextStyle(color: AppColors.gold)),
          bottom: const TabBar(
            indicatorColor: AppColors.gold,
            labelColor: AppColors.gold,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BookingsList(isPast: false),
            _BookingsList(isPast: true),
          ],
        ),
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final bool isPast;
  const _BookingsList({required this.isPast});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.paddingMid),
      itemCount: isPast ? 5 : 2,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSizes.gapMid),
          padding: const EdgeInsets.all(AppSizes.paddingMid),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radiusMid),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary),
              ),
              const SizedBox(width: AppSizes.gapMid),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPast ? 'Consultation with Jhon Smith' : 'Upcoming with Laura Lim',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.fontMedium),
                    ),
                    Text(
                      '15 April 2026, 10:00 AM',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: AppSizes.fontXS),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPast ? AppColors.greyLight : AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isPast ? 'Completed' : 'Upcoming',
                        style: TextStyle(
                          color: isPast ? AppColors.textSecondary : AppColors.success,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.grey),
            ],
          ),
        );
      },
    );
  }
}
