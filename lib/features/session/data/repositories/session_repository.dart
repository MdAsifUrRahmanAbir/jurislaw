import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/json_utils.dart';
import '../models/session_models.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(ref.watch(apiClientProvider));
});

/// Live session & chat — A7.1 to A7.4.
class SessionRepository {
  final ApiClient _apiClient;
  SessionRepository(this._apiClient);

  /// GET /session/{booking_id} — the first call records the join and
  /// notifies the advocate. 403 carries `data.code`
  /// (`payment_required` / `not_confirmed`).
  Future<SessionRoom> openRoom(String bookingId) async {
    final response = await _apiClient.get(ApiEndpoints.session(bookingId));
    return SessionRoom.fromData(Json.data(response.data), bookingId);
  }

  /// GET /session/{booking_id}/messages?after= — up to 200 per call.
  Future<MessagesPage> fetchMessages(String bookingId, {int after = 0}) async {
    final response = await _apiClient.get(
      ApiEndpoints.sessionMessages(bookingId),
      queryParameters: {'after': after},
    );
    return MessagesPage.fromBody(response.data);
  }

  /// POST /session/{booking_id}/message — max 5000 chars.
  Future<ChatMessage?> sendMessage(String bookingId, String message) async {
    final response = await _apiClient.post(
      ApiEndpoints.sessionSendMessage(bookingId),
      data: {'message': message},
    );
    final data = Json.data(response.data);
    final json = Json.map(data, const ['message']) ?? data;
    return json['id'] == null ? null : ChatMessage.fromJson(json);
  }

  /// POST /session/{booking_id}/end
  Future<EndSessionResult> endSession(String bookingId) async {
    final response = await _apiClient.post(ApiEndpoints.sessionEnd(bookingId));
    final data = Json.data(response.data);
    return EndSessionResult(code: Json.stringOrNull(data, const ['code']), message: Json.message(response.data));
  }
}
