import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../core/utils/json_utils.dart';
import '../models/booking_model.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(ref.watch(apiClientProvider));
});

/// Client consultations — A5.1 to A5.6.
class BookingRepository {
  final ApiClient _apiClient;
  BookingRepository(this._apiClient);

  /// GET /bookings — newest first, 20 per page.
  Future<PaginatedResponse<BookingModel>> fetchBookings({int page = 1}) async {
    final response = await _apiClient.get(ApiEndpoints.myBookings, queryParameters: {'page': page});
    return PaginatedResponse.fromBody(
      response.data,
      BookingModel.fromJson,
      requestedPage: page,
      listKeys: const ['data', 'bookings'],
    );
  }

  /// GET /bookings/{id}
  Future<BookingModel> fetchBooking(String bookingId) async {
    final response = await _apiClient.get(ApiEndpoints.bookingDetail(bookingId));
    final data = Json.data(response.data);
    return BookingModel.fromJson(Json.map(data, const ['booking']) ?? data);
  }

  /// POST /schedules/{id}/book — 201 with the new booking in
  /// `pending_payment`; the slot is held for 15 minutes.
  Future<BookingModel> bookSlot(String scheduleId, {required String caseDetails}) async {
    final response = await _apiClient.post(
      ApiEndpoints.bookSlot(scheduleId),
      data: {'case_details': caseDetails},
    );
    final data = Json.data(response.data);
    return BookingModel.fromJson(Json.map(data, const ['booking']) ?? data);
  }

  /// POST /bookings/{id}/reschedule/accept — returns the server message.
  Future<String?> acceptReschedule(String bookingId) async {
    final response = await _apiClient.post(ApiEndpoints.rescheduleAccept(bookingId));
    return Json.message(response.data);
  }

  /// POST /bookings/{id}/reschedule/decline — the decline always stands;
  /// only the optional counter-offer can fail. Read the message.
  Future<String?> declineReschedule(String bookingId, {String? requestedScheduleId}) async {
    final response = await _apiClient.post(
      ApiEndpoints.rescheduleDecline(bookingId),
      data: {'requested_schedule_id': ?requestedScheduleId},
    );
    return Json.message(response.data);
  }

  /// POST /bookings/{id}/cancel — cancels a paid booking and opens a refund.
  Future<String?> cancelBooking(String bookingId, {required String reason}) async {
    final response = await _apiClient.post(
      ApiEndpoints.bookingCancel(bookingId),
      data: {'cancellation_reason': reason},
    );
    return Json.message(response.data);
  }
}
