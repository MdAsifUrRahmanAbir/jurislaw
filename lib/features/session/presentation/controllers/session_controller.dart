import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/error_mapper.dart';
import '../../../bookings/presentation/controllers/bookings_controller.dart';
import '../../data/models/session_models.dart';
import '../../data/repositories/session_repository.dart';

class SessionState {
  final SessionRoom? room;
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isOpen;
  final bool isSending;
  final bool isEnding;
  final String? errorMessage;

  /// `payment_required` / `not_confirmed` / `forbidden` when the room
  /// refused to open (A7.1 403).
  final String? blockedCode;

  /// Last A7.4 result code (`waiting_for_other`, `both_ended`, …).
  final String? endCode;

  const SessionState({
    this.room,
    this.messages = const [],
    this.isLoading = true,
    this.isOpen = false,
    this.isSending = false,
    this.isEnding = false,
    this.errorMessage,
    this.blockedCode,
    this.endCode,
  });

  int get lastMessageId => messages.isEmpty ? 0 : messages.last.id;
  bool get waitingForOther => endCode == 'waiting_for_other' || (room?.endedByMe ?? false);

  SessionState copyWith({
    SessionRoom? room,
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isOpen,
    bool? isSending,
    bool? isEnding,
    String? errorMessage,
    String? blockedCode,
    String? endCode,
  }) {
    return SessionState(
      room: room ?? this.room,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isOpen: isOpen ?? this.isOpen,
      isSending: isSending ?? this.isSending,
      isEnding: isEnding ?? this.isEnding,
      errorMessage: errorMessage,
      blockedCode: blockedCode ?? this.blockedCode,
      endCode: endCode ?? this.endCode,
    );
  }
}

/// The live session room for one booking: opens it (A7.1), polls new
/// messages every few seconds while it is open (A7.2), sends (A7.3) and
/// ends (A7.4).
class SessionController extends Notifier<SessionState> {
  SessionController(this.bookingId);

  final String bookingId;
  static const _pollEvery = Duration(seconds: 3);
  Timer? _pollTimer;
  bool _polling = false;

  @override
  SessionState build() {
    ref.onDispose(() => _pollTimer?.cancel());
    Future.microtask(load);
    return const SessionState();
  }

  SessionRepository get _repository => ref.read(sessionRepositoryProvider);

  Future<void> load() async {
    _pollTimer?.cancel();
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final room = await _repository.openRoom(bookingId);
      final page = await _repository.fetchMessages(bookingId);
      state = SessionState(
        room: room,
        messages: page.messages,
        isLoading: false,
        isOpen: page.isOpen && (room.isOpen || !room.isWaitingToOpen),
        endCode: state.endCode,
      );
      _schedulePoll();
    } on ApiException catch (e) {
      if (e.statusCode == 403) {
        state = SessionState(isLoading: false, blockedCode: e.code ?? 'forbidden', errorMessage: e.message);
      } else {
        state = state.copyWith(isLoading: false, errorMessage: getErrorMessage(e));
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: getErrorMessage(e));
    }
  }

  void _schedulePoll() {
    _pollTimer?.cancel();
    if (!state.isOpen) return;
    _pollTimer = Timer.periodic(_pollEvery, (_) => poll());
  }

  /// Fetches messages after the last one we have. Stops when the API
  /// reports the session closed.
  Future<void> poll() async {
    if (_polling) return;
    _polling = true;
    try {
      final page = await _repository.fetchMessages(bookingId, after: state.lastMessageId);
      final known = state.messages.map((m) => m.id).toSet();
      final fresh = page.messages.where((m) => !known.contains(m.id)).toList();
      state = state.copyWith(
        messages: fresh.isEmpty ? null : [...state.messages, ...fresh],
        isOpen: page.isOpen,
      );
      if (!page.isOpen) {
        _pollTimer?.cancel();
        ref.invalidate(bookingsControllerProvider);
      }
    } catch (_) {
      // Transient poll errors are ignored; the next tick retries.
    } finally {
      _polling = false;
    }
  }

  Future<bool> send(String text) async {
    final message = text.trim();
    if (message.isEmpty || state.isSending) return false;
    state = state.copyWith(isSending: true, errorMessage: null);
    try {
      final sent = await _repository.sendMessage(bookingId, message);
      if (sent != null && !state.messages.any((m) => m.id == sent.id)) {
        final mine = ChatMessage(id: sent.id, message: sent.message, isMe: true, createdAt: sent.createdAt ?? DateTime.now());
        state = state.copyWith(messages: [...state.messages, mine], isSending: false);
      } else {
        state = state.copyWith(isSending: false);
      }
      await poll();
      return true;
    } catch (e) {
      state = state.copyWith(isSending: false, errorMessage: getErrorMessage(e));
      return false;
    }
  }

  /// Returns a user-facing message describing the result.
  Future<String?> end() async {
    if (state.isEnding) return null;
    state = state.copyWith(isEnding: true, errorMessage: null);
    try {
      final result = await _repository.endSession(bookingId);
      state = state.copyWith(isEnding: false, endCode: result.code ?? 'waiting_for_other');
      if (result.bothEnded) {
        state = state.copyWith(isOpen: false);
        _pollTimer?.cancel();
        ref.invalidate(bookingsControllerProvider);
        return result.message ?? 'Session ended. Thank you!';
      }
      return result.message ?? 'You ended the session. Waiting for the advocate to end it too.';
    } on ApiException catch (e) {
      final code = e.code;
      state = state.copyWith(isEnding: false, endCode: code);
      if (code == 'already_closed') {
        state = state.copyWith(isOpen: false);
        _pollTimer?.cancel();
      }
      state = state.copyWith(errorMessage: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(isEnding: false, errorMessage: getErrorMessage(e));
      return null;
    }
  }
}

final sessionControllerProvider =
    NotifierProvider.autoDispose.family<SessionController, SessionState, String>(SessionController.new);
