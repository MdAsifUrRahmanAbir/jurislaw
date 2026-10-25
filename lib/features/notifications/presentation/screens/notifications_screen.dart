import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/utils/responsive.dart';
import 'notifications_mobile_view.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Responsive(
        mobile: NotificationsMobileView(),
        tablet: NotificationsMobileView(maxWidth: 640),
      ),
    );
  }
}
