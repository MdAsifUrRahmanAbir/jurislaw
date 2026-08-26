import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_test/core/utils/responsive.dart';
import 'bookings_mobile_view.dart';
import 'bookings_tab_view.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Responsive(
        mobile: const BookingsMobileView(),
        tablet: const BookingsTabView(),
      ),
    );
  }
}
