import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/gradient_cover_header.dart';

/// Cover gradient + avatar, name, and phone number at the top of the
/// profile screen.
class ProfileHeader extends StatelessWidget {
  final String name;
  final String phone;
  final String? avatarUrl;
  final VoidCallback? onAvatarEditTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.phone,
    this.avatarUrl,
    this.onAvatarEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientCoverHeader(
          avatarUrl: avatarUrl,
          avatarLabel: name,
          onAvatarEditTap: onAvatarEditTap,
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          name,
          style: TextStyle(fontSize: AppSizes.fontXxl, fontWeight: FontWeight.w700, color: context.appColors.textPrimary),
        ),
        const SizedBox(height: AppSizes.xs),
        Text(
          phone,
          style: TextStyle(fontSize: AppSizes.fontSm, color: context.appColors.textSecondary),
        ),
      ],
    );
  }
}
