part of '../views/login_view.dart';

class LoginBranding extends StatelessWidget {
  const LoginBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMid),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSizes.radiusMid),
        ),
        child: const Icon(Icons.gavel_rounded, color: AppColors.gold, size: 50),
      ),
    );
  }
}
