import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/localization/gen/app_localizations.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/common/custom_card.dart';
import '../../../../routes/route_names.dart';
import '../widgets/login_header.dart';
import '../widgets/login_form.dart';
import '../widgets/register_prompt.dart';

class LoginMobileView extends ConsumerWidget {
  const LoginMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(title: AppLocalizations.of(context)!.signIn),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LoginHeader(),
                        const SizedBox(height: AppSizes.lg),
                        LoginForm(
                          onOtpSent: (phone) => context.push(RouteNames.otpVerification, extra: phone),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  const RegisterPrompt(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
