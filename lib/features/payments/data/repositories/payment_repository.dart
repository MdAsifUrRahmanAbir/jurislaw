import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/paginated_response.dart';
import '../../../../core/utils/json_utils.dart';
import '../models/payment_models.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ref.watch(apiClientProvider));
});

/// SSLCommerz payments — A6.1 to A6.4. Only the gateway's validated
/// callbacks move money; the status endpoint is read-only.
class PaymentRepository {
  final ApiClient _apiClient;
  PaymentRepository(this._apiClient);

  /// GET /bookings/{id}/payment — 400 when already paid or not payable.
  Future<CheckoutSummary> fetchCheckout(String bookingId) async {
    final response = await _apiClient.get(ApiEndpoints.bookingPaymentSummary(bookingId));
    return CheckoutSummary.fromData(Json.data(response.data), bookingId);
  }

  /// POST /bookings/{id}/pay — safe to repeat; an abandoned checkout
  /// reuses the same pending payment.
  Future<PaymentSession> startPayment(String bookingId) async {
    final response = await _apiClient.post(ApiEndpoints.bookingPay(bookingId));
    return PaymentSession.fromData(Json.data(response.data));
  }

  /// GET /payments/{transaction_id}
  Future<PaymentStatus> fetchStatus(String transactionId) async {
    final response = await _apiClient.get(ApiEndpoints.paymentStatus(transactionId));
    return PaymentStatus.fromData(Json.data(response.data), transactionId);
  }

  /// GET /payments — newest first, 20 per page.
  Future<PaginatedResponse<PaymentReceipt>> fetchReceipts({int page = 1}) async {
    final response = await _apiClient.get(ApiEndpoints.myPayments, queryParameters: {'page': page});
    return PaginatedResponse.fromBody(
      response.data,
      PaymentReceipt.fromJson,
      requestedPage: page,
      listKeys: const ['data', 'payments'],
    );
  }
}
