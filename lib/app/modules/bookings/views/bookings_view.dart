import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_structure/app/core/constants/app_colors.dart';
import '../widgets/bookings_list_widget.dart';

part 'bookings_mobile.dart';
part 'bookings_tab.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return const BookingsTab();
        }
        return const BookingsMobile();
      },
    );
  }
}
