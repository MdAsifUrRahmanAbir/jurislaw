import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/widgets/common/gradient_cover_header.dart';

/// Cover gradient + avatar, name, phone, email and address at the top of
/// the profile screen.
class ProfileHeader extends StatelessWidget {
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final String? avatarUrl;
  final VoidCallback? onAvatarEditTap;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.avatarUrl,
    this.onAvatarEditTap,
  });

  Widget _line(BuildContext context, IconData icon, String text) => Padding(
        padding: const EdgeInsets.only(top: AppSizes.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: context.appColors.textSecondary),
            const SizedBox(width: AppSizes.xs),
            Flexible(
              child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: AppSizes.fontSm, color: context.appColors.textSecondary)),
            ),
          ],
        ),
      );

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
        if (phone.isNotEmpty) _line(context, Icons.phone_outlined, phone),
        if (email != null && email!.isNotEmpty) _line(context, Icons.mail_outline_rounded, email!),
        if (address != null && address!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: _line(context, Icons.location_on_outlined, address!),
          ),
      ],
    );
  }
}
