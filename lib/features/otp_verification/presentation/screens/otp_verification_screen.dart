import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ukil_chaai/core/utils/responsive.dart';
import 'otp_verification_mobile_view.dart';
import 'otp_verification_tab_view.dart';

class OtpVerificationScreen extends ConsumerWidget {
  final String phone;

  const OtpVerificationScreen({super.key, required this.phone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Responsive(
        mobile: OtpVerificationMobileView(phone: phone),
        tablet: OtpVerificationTabView(phone: phone),
      ),
    );
  }
}
