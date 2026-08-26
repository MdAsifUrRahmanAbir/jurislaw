import 'package:flutter/material.dart';
import '../../../bookings/presentation/screens/bookings_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../lawyer_list/presentation/screens/lawyer_list_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

/// Hosts all four bottom-nav destination screens in an [IndexedStack]
/// so switching tabs preserves each screen's scroll position and
/// state instead of rebuilding it from scratch every time.
class ShellTabBody extends StatelessWidget {
  final int selectedIndex;

  const ShellTabBody({super.key, required this.selectedIndex});

  static const _screens = [
    HomeScreen(),
    LawyerListScreen(),
    BookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return IndexedStack(index: selectedIndex, children: _screens);
  }
}
