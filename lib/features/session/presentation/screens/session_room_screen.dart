import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/common/initials_avatar.dart';
import '../../../../core/widgets/common/primary_button.dart';
import '../../../../core/widgets/utility/custom_alert_dialog.dart';
import '../../../../core/widgets/utility/custom_loader.dart';
import '../../../../core/widgets/utility/custom_snackbar.dart';
import '../../../../core/widgets/utility/error_state.dart';
import '../../../../routes/route_names.dart';
import '../../data/models/session_models.dart';
import '../controllers/session_controller.dart';
import '../widgets/chat_bubble.dart';

/// Live consultation room (A7) — text chat with the advocate.
class SessionRoomScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const SessionRoomScreen({super.key, required this.bookingId});

  @override
  ConsumerState<SessionRoomScreen> createState() => _SessionRoomScreenState();
}

class _SessionRoomScreenState extends ConsumerState<SessionRoomScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  NotifierProvider<SessionController, SessionState> get _provider => sessionControllerProvider(widget.bookingId);

  Future<void> _send() async {
    final text = _input.text;
    if (text.trim().isEmpty) return;
    _input.clear();
    final ok = await ref.read(_provider.notifier).send(text);
    if (!ok) _input.text = text;
  }

  Future<void> _end() async {
    final confirmed = await CustomAlertDialog.confirm(
      context,
      title: 'End session?',
      message: 'The consultation closes once both you and the advocate end it.',
      confirmText: 'End session',
      destructive: true,
    );
    if (confirmed != true) return;
    final message = await ref.read(_provider.notifier).end();
    if (message != null && mounted) CustomSnackbar.show(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final controller = ref.read(_provider.notifier);
    final room = state.room;

    ref.listen(_provider, (previous, next) {
      if (next.room != null && next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        CustomSnackbar.show(context, next.errorMessage!, error: true);
      }
      if ((previous?.messages.length ?? 0) != next.messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scroll.hasClients) _scroll.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
        });
      }
    });

    Widget body;
    if (state.isLoading && room == null) {
      body = const CustomLoader(label: 'Opening session room…');
    } else if (state.blockedCode != null) {
      body = _BlockedView(code: state.blockedCode!, message: state.errorMessage, bookingId: widget.bookingId);
    } else if (room == null) {
      body = ErrorState(message: state.errorMessage ?? 'Could not open the session.', onRetry: controller.load);
    } else if (room.isWaitingToOpen) {
      body = _WaitingView(room: room, onOpen: controller.load);
    } else {
      body = Column(
        children: [
          if (room.counterparty.phone != null || room.counterparty.email != null) _ContactStrip(counterparty: room.counterparty),
          if (!state.isOpen)
            _StatusStrip(color: AppColors.textSecondary, icon: Icons.lock_outline_rounded, text: 'This session is closed. The chat is read-only.')
          else if (state.waitingForOther)
            const _StatusStrip(color: AppColors.info, icon: Icons.hourglass_top_rounded, text: 'You ended the session — waiting for the advocate to end it too.'),
          Expanded(
            child: state.messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.xl),
                      child: Text(
                        state.isOpen ? 'Say hello to ${room.counterparty.name} and describe your issue.' : 'No messages in this session.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.appColors.textSecondary),
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scroll,
                    reverse: true,
                    padding: const EdgeInsets.all(AppSizes.md),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) => ChatBubble(message: state.messages[state.messages.length - 1 - index]),
                  ),
          ),
          if (state.isOpen) _Composer(controller: _input, sending: state.isSending, onSend: _send),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.appColors.surface,
        titleSpacing: 0,
        title: room == null
            ? const Text('Session')
            : Row(
                children: [
                  InitialsAvatar(name: room.counterparty.name, imageUrl: room.counterparty.photoUrl, size: 36),
                  const SizedBox(width: AppSizes.sm + AppSizes.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(room.counterparty.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: AppSizes.fontMd, fontWeight: FontWeight.w700)),
                        Text(
                          state.isOpen ? 'Live session' : 'Session closed',
                          style: TextStyle(fontSize: AppSizes.fontXs, color: state.isOpen ? AppColors.success : context.appColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        actions: [
          if (room != null && state.isOpen && !state.waitingForOther)
            TextButton(
              onPressed: state.isEnding ? null : _end,
              child: state.isEnding
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('End', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
            ),
        ],
      ),
      body: SafeArea(top: false, child: body),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  const _Composer({required this.controller, required this.sending, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSizes.sm + AppSizes.xs, AppSizes.sm, AppSizes.sm, AppSizes.sm),
      color: colors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 5,
              maxLength: 5000,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Type a message…',
                counterText: '',
                filled: true,
                fillColor: colors.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 2),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSizes.radiusXl), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.xs),
          IconButton.filled(
            onPressed: sending ? null : onSend,
            style: IconButton.styleFrom(backgroundColor: AppColors.primary),
            icon: sending
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textWhite))
                : const Icon(Icons.send_rounded, color: AppColors.textWhite),
          ),
        ],
      ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;

  const _StatusStrip({required this.color, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
      color: color.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(icon, size: AppSizes.iconSm, color: color),
          const SizedBox(width: AppSizes.sm),
          Expanded(child: Text(text, style: TextStyle(fontSize: AppSizes.fontXs, fontWeight: FontWeight.w600, color: color))),
        ],
      ),
    );
  }
}

class _ContactStrip extends StatelessWidget {
  final SessionCounterparty counterparty;

  const _ContactStrip({required this.counterparty});

  @override
  Widget build(BuildContext context) {
    final parts = [
      if (counterparty.phone != null) counterparty.phone!,
      if (counterparty.email != null) counterparty.email!,
    ];
    return _StatusStrip(color: AppColors.primary, icon: Icons.contact_phone_outlined, text: 'Advocate contact: ${parts.join(' · ')}');
  }
}

/// Before `join_opens_at` (10 minutes before the start): a countdown that
/// re-opens the room when it reaches zero.
class _WaitingView extends StatefulWidget {
  final SessionRoom room;
  final Future<void> Function() onOpen;

  const _WaitingView({required this.room, required this.onOpen});

  @override
  State<_WaitingView> createState() => _WaitingViewState();
}

class _WaitingViewState extends State<_WaitingView> {
  late final Timer _timer;
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (!widget.room.isWaitingToOpen && !_opening) {
        _opening = true;
        widget.onOpen();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final left = widget.room.joinOpensAt!.difference(DateTime.now());
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule_rounded, size: 64, color: AppColors.primary),
            const SizedBox(height: AppSizes.md),
            Text('The room opens soon', style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700, color: colors.textPrimary)),
            const SizedBox(height: AppSizes.sm),
            if (widget.room.startsAt != null)
              Text('Session starts ${DateFormatter.dayTime(widget.room.startsAt!)}', style: TextStyle(color: colors.textSecondary)),
            const SizedBox(height: AppSizes.lg),
            Text(
              DateFormatter.countdown(left),
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: colors.textPrimary, fontFeatures: const [FontFeature.tabularFigures()]),
            ),
            const SizedBox(height: AppSizes.sm),
            Text('You can join 10 minutes before the start.', style: TextStyle(fontSize: AppSizes.fontSm, color: colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _BlockedView extends StatelessWidget {
  final String code;
  final String? message;
  final String bookingId;

  const _BlockedView({required this.code, required this.message, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (title, body, action) = switch (code) {
      'payment_required' => ('Payment required', 'Pay for this booking to open the session room.', 'Go to checkout'),
      'not_confirmed' => ('Not confirmed yet', 'The advocate has not confirmed this booking yet, or it was rejected.', 'View booking'),
      _ => ('Not available', message ?? 'You are not a participant of this session.', null),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 64, color: AppColors.warning),
            const SizedBox(height: AppSizes.md),
            Text(title, style: TextStyle(fontSize: AppSizes.fontXl, fontWeight: FontWeight.w700, color: colors.textPrimary)),
            const SizedBox(height: AppSizes.sm),
            Text(body, textAlign: TextAlign.center, style: TextStyle(color: colors.textSecondary)),
            if (action != null) ...[
              const SizedBox(height: AppSizes.lg),
              PrimaryButton(
                label: action,
                onPressed: () => context.pushReplacement(
                  code == 'payment_required' ? RouteNames.checkoutPath(bookingId) : RouteNames.bookingDetailsPath(bookingId),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
