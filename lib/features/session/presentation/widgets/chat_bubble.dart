import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/models/session_models.dart';

/// One message. Rendered with [SelectableText] (plain text), never as
/// HTML — messages are stored exactly as typed.
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final mine = message.isMe;
    final colors = context.appColors;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: AppSizes.xs),
          padding: const EdgeInsets.fromLTRB(AppSizes.sm + AppSizes.xs, AppSizes.sm, AppSizes.sm + AppSizes.xs, AppSizes.xs + 2),
          decoration: BoxDecoration(
            color: mine ? AppColors.primary : colors.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(AppSizes.radiusLg),
              topRight: const Radius.circular(AppSizes.radiusLg),
              bottomLeft: Radius.circular(mine ? AppSizes.radiusLg : AppSizes.xs),
              bottomRight: Radius.circular(mine ? AppSizes.xs : AppSizes.radiusLg),
            ),
          ),
          child: Column(
            crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              SelectableText(
                message.message,
                style: TextStyle(color: mine ? AppColors.textWhite : colors.textPrimary, height: 1.35),
              ),
              if (message.createdAt != null) ...[
                const SizedBox(height: 2),
                Text(
                  DateFormatter.time(message.createdAt!),
                  style: TextStyle(fontSize: 10, color: mine ? AppColors.textWhite.withValues(alpha: 0.75) : colors.textHint),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
