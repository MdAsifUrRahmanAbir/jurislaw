import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/utils/responsive.dart';
import 'profile_mobile_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: Responsive(
        mobile: ProfileMobileView(),
        tablet: ProfileMobileView(maxWidth: 640),
      ),
    );
  }
}
