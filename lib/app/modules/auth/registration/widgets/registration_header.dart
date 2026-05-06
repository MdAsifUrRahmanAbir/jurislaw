part of '../views/registration_view.dart';

class RegistrationHeader extends StatelessWidget {
  const RegistrationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Complete Your Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        SizedBox(height: AppSizes.gapXSmall),
        Text(
          "You're almost there! Let's get to know you better.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppSizes.fontMedium,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
