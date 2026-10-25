import '../../../../core/utils/json_utils.dart';

/// The other participant. Phone/email are only exchanged inside the
/// paid session, so they may be present here.
class SessionCounterparty {
  final String name;
  final String? photoUrl;
  final String? phone;
  final String? email;

  const SessionCounterparty({required this.name, this.photoUrl, this.phone, this.email});

  factory SessionCounterparty.fromJson(Map<String, dynamic>? json) => SessionCounterparty(
        name: Json.string(json, const ['name'], 'Advocate'),
        photoUrl: Json.stringOrNull(json, const ['profile_photo_url', 'photo_url', 'photo', 'avatar']),
        phone: Json.stringOrNull(json, const ['phone']),
        email: Json.stringOrNull(json, const ['email']),
      );
}

/// A7.1 — the session room.
class SessionRoom {
  final String bookingId;
  final String role;
  final DateTime? joinOpensAt;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool isOpen;
  final String? status;
  final bool endedByMe;
  final bool endedByOther;
  final SessionCounterparty counterparty;

  const SessionRoom({
    required this.bookingId,
    this.role = 'client',
    this.joinOpensAt,
    this.startsAt,
    this.endsAt,
    this.isOpen = false,
    this.status,
    this.endedByMe = false,
    this.endedByOther = false,
    required this.counterparty,
  });

  bool get isWaitingToOpen => joinOpensAt != null && DateTime.now().isBefore(joinOpensAt!);

  factory SessionRoom.fromData(Map<String, dynamic> data, String bookingId) {
    final session = Json.map(data, const ['session']) ?? data;
    final role = Json.string(session, const ['role'], 'client');
    final clientEnded = Json.pick(session, const ['client_ended_at', 'client_ended']);
    final advocateEnded = Json.pick(session, const ['advocate_ended_at', 'advocate_ended']);
    bool ended(dynamic v) => v != null && v != false && v != 0 && v.toString().isNotEmpty;
    return SessionRoom(
      bookingId: Json.string(session, const ['booking_id'], bookingId),
      role: role,
      joinOpensAt: Json.date(session, const ['join_opens_at']),
      startsAt: Json.date(session, const ['starts_at', 'start_at']),
      endsAt: Json.date(session, const ['ends_at', 'end_at']),
      isOpen: Json.boolean(session, const ['is_open'], Json.boolean(data, const ['is_open'])),
      status: Json.stringOrNull(session, const ['status']),
      endedByMe: Json.boolean(session, const ['ended_by_me']) || ended(role == 'client' ? clientEnded : advocateEnded),
      endedByOther: Json.boolean(session, const ['ended_by_other']) || ended(role == 'client' ? advocateEnded : clientEnded),
      counterparty: SessionCounterparty.fromJson(
        Json.map(data, const ['counterparty']) ?? Json.map(session, const ['counterparty', 'advocate']),
      ),
    );
  }
}

/// One chat message (A7.2). Messages are stored as typed — render them as
/// plain text, never as HTML.
class ChatMessage {
  final int id;
  final String message;
  final bool isMe;
  final DateTime? createdAt;
  final String? senderName;

  const ChatMessage({required this.id, required this.message, required this.isMe, this.createdAt, this.senderName});

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: Json.integer(json, const ['id']),
        message: Json.string(json, const ['message', 'body', 'text']),
        isMe: Json.boolean(json, const ['is_me', 'mine']),
        createdAt: Json.date(json, const ['created_at', 'sent_at']),
        senderName: Json.stringOrNull(json, const ['sender_name', 'sender']),
      );
}

class MessagesPage {
  final List<ChatMessage> messages;
  final bool isOpen;

  const MessagesPage({required this.messages, required this.isOpen});

  factory MessagesPage.fromBody(dynamic body) {
    final root = body is Map ? Map<String, dynamic>.from(body) : <String, dynamic>{};
    var raw = Json.maps(root, const ['data', 'messages']);
    final data = Json.map(root, const ['data']);
    if (raw.isEmpty && data != null) raw = Json.maps(data, const ['messages', 'data']);
    final meta = Json.map(root, const ['meta']);
    final isOpen = Json.pick(root, const ['is_open']) ?? Json.pick(data, const ['is_open']) ?? Json.pick(meta, const ['is_open']);
    return MessagesPage(
      messages: raw.map(ChatMessage.fromJson).toList(),
      isOpen: isOpen == null ? true : Json.boolean({'v': isOpen}, const ['v']),
    );
  }
}

/// A7.4 result — `data.code` tells what happened.
class EndSessionResult {
  final String? code;
  final String? message;

  const EndSessionResult({this.code, this.message});

  bool get bothEnded => code == 'both_ended';
}
