import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/utils/responsive.dart';
import 'bookings_mobile_view.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Responsive(
        mobile: BookingsMobileView(),
        tablet: BookingsMobileView(maxWidth: 680),
      ),
    );
  }
}
