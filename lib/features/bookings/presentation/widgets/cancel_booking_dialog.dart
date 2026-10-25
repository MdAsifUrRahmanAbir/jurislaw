import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';

/// Asks for the cancellation reason (5–500 chars). Returns it, or null.
Future<String?> showCancelBookingDialog(BuildContext context) {
  return showDialog<String>(context: context, builder: (_) => const _CancelDialog());
}

class _CancelDialog extends StatefulWidget {
  const _CancelDialog();

  @override
  State<_CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<_CancelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.appColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.radiusLg)),
      title: const Text('Cancel booking?'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A refund will be opened and settled by our team. Please tell us why you are cancelling.',
              style: TextStyle(color: context.appColors.textSecondary),
            ),
            const SizedBox(height: AppSizes.md),
            TextFormField(
              controller: _controller,
              maxLines: 3,
              maxLength: 500,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Reason for cancelling',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusMd)),
              ),
              validator: (value) => (value?.trim().length ?? 0) < 5 ? 'Please write at least 5 characters.' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Keep booking')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) Navigator.pop(context, _controller.text.trim());
          },
          child: const Text('Cancel booking'),
        ),
      ],
    );
  }
}
