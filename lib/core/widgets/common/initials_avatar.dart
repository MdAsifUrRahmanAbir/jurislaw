import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';

/// Rounded-square avatar: the photo when there is one, otherwise the
/// person's initials on a color picked from their name (stable per
/// person) — the same look the web directory uses for advocates.
class InitialsAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final double? radius;

  const InitialsAvatar({super.key, required this.name, this.imageUrl, this.size = 48, this.radius});

  static const _palette = [
    Color(0xFF0891B2),
    Color(0xFFBE123C),
    Color(0xFF9333EA),
    Color(0xFFB08D57),
    Color(0xFF059669),
    Color(0xFFC2410C),
    Color(0xFF4F46E5),
    Color(0xFF0D9488),
  ];

  static String initialsOf(String name) {
    final words = name
        .replaceAll(RegExp(r'^(Adv\.?|Advocate)\s+', caseSensitive: false), '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first[0].toUpperCase();
    return (words.first[0] + words.last[0]).toUpperCase();
  }

  Color get _color => _palette[name.codeUnits.fold<int>(0, (a, b) => a + b) % _palette.length];

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius ?? size * 0.22);
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: _color, borderRadius: borderRadius),
      child: Text(
        initialsOf(name),
        style: TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.w700, fontSize: size * 0.36),
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) return fallback;

    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, _) => fallback,
        errorWidget: (_, _, _) => fallback,
      ),
    );
  }
}

/// Small rounded tag (practice areas, session type).
class TagChip extends StatelessWidget {
  final String label;
  final Color? color;

  const TagChip({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final tint = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm + 2, vertical: AppSizes.xs),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: tint.withValues(alpha: 0.25)),
      ),
      child: Text(label, style: TextStyle(fontSize: AppSizes.fontXs, fontWeight: FontWeight.w600, color: tint)),
    );
  }
}
