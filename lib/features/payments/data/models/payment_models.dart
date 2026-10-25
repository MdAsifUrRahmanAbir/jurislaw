import '../../../../core/utils/json_utils.dart';

/// A6.1 — fee breakdown. The advocate gets their full price and the
/// platform charge is added on top; [total] is what the client pays.
class CheckoutSummary {
  final String bookingId;
  final double advocateFee;
  final double platformCharge;
  final double total;
  final DateTime? reservedUntil;
  final bool gatewayAvailable;
  final String advocateName;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String? sessionType;
  final List<MapEntry<String, double>> extraLines;

  const CheckoutSummary({
    required this.bookingId,
    required this.advocateFee,
    required this.platformCharge,
    required this.total,
    this.reservedUntil,
    this.gatewayAvailable = true,
    this.advocateName = '',
    this.startsAt,
    this.endsAt,
    this.sessionType,
    this.extraLines = const [],
  });

  factory CheckoutSummary.fromData(Map<String, dynamic> data, String bookingId) {
    final quote = Json.map(data, const ['quote', 'breakdown']) ?? data;
    final booking = Json.map(data, const ['booking']);
    final advocate = Json.map(booking, const ['advocate']) ?? Json.map(data, const ['advocate']);
    const knownKeys = {
      'advocate_fee', 'advocate_price', 'fee', 'price', 'subtotal', 'amount',
      'platform_charge', 'platform_fee', 'service_charge', 'charge', 'total', 'currency',
    };
    final total = Json.number(quote, const ['total', 'grand_total', 'payable']);
    final fee = Json.numberOrNull(quote, const ['advocate_fee', 'advocate_price', 'fee', 'price', 'subtotal', 'amount']);
    final charge = Json.numberOrNull(quote, const ['platform_charge', 'platform_fee', 'service_charge', 'charge']);
    return CheckoutSummary(
      bookingId: Json.string(booking, const ['id'], bookingId),
      advocateFee: fee ?? (total - (charge ?? 0)),
      platformCharge: charge ?? (fee != null ? total - fee : 0),
      total: total,
      reservedUntil: Json.date(booking, const ['reserved_until']) ?? Json.date(data, const ['reserved_until']),
      gatewayAvailable: Json.boolean(data, const ['gateway_available'], true),
      advocateName: Json.string(advocate, const ['name']),
      startsAt: Json.date(booking, const ['starts_at', 'start_at']),
      endsAt: Json.date(booking, const ['ends_at', 'end_at']),
      sessionType: Json.stringOrNull(booking, const ['session_type_label', 'session_type']),
      extraLines: [
        for (final entry in quote.entries)
          if (!knownKeys.contains(entry.key) && Json.toDouble(entry.value) != null)
            MapEntry(entry.key, Json.toDouble(entry.value)!),
      ],
    );
  }
}

/// A6.2 — open [gatewayUrl] in a web view and close it when it reaches any
/// of [returnUrls].
class PaymentSession {
  final String transactionId;
  final String gatewayUrl;
  final List<String> returnUrls;

  const PaymentSession({required this.transactionId, required this.gatewayUrl, required this.returnUrls});

  factory PaymentSession.fromData(Map<String, dynamic> data) {
    final rawReturn = Json.pick(data, const ['return_urls', 'callback_urls']);
    final urls = <String>[];
    if (rawReturn is Map) {
      urls.addAll(rawReturn.values.where((v) => v != null).map((v) => v.toString()));
    } else if (rawReturn is List) {
      urls.addAll(rawReturn.where((v) => v != null).map((v) => v.toString()));
    } else if (rawReturn != null) {
      urls.add(rawReturn.toString());
    }
    return PaymentSession(
      transactionId: Json.string(data, const ['transaction_id', 'tran_id']),
      gatewayUrl: Json.string(data, const ['gateway_url', 'GatewayPageURL', 'redirect_url', 'url']),
      returnUrls: urls,
    );
  }
}

/// A6.3 — poll while [isPending].
class PaymentStatus {
  final String transactionId;
  final String status;
  final bool isPaid;
  final bool isPending;
  final String? bookingId;
  final double? total;

  const PaymentStatus({
    required this.transactionId,
    required this.status,
    required this.isPaid,
    required this.isPending,
    this.bookingId,
    this.total,
  });

  bool get isFailed => !isPaid && !isPending;

  factory PaymentStatus.fromData(Map<String, dynamic> data, String transactionId) {
    final json = Json.map(data, const ['payment']) ?? data;
    final status = Json.string(json, const ['status'], 'pending');
    return PaymentStatus(
      transactionId: Json.string(json, const ['transaction_id'], transactionId),
      status: status,
      isPaid: Json.boolean(json, const ['is_paid'], status == 'paid'),
      isPending: Json.boolean(json, const ['is_pending'], status == 'pending'),
      bookingId: Json.stringOrNull(json, const ['booking_id']),
      total: Json.numberOrNull(json, const ['total', 'amount']),
    );
  }
}

/// A6.4 — one receipt row.
class PaymentReceipt {
  final String transactionId;
  final String status;
  final double total;
  final String? method;
  final DateTime? paidAt;
  final String? bookingId;
  final String advocateName;
  final String? refundStatus;

  const PaymentReceipt({
    required this.transactionId,
    required this.status,
    required this.total,
    this.method,
    this.paidAt,
    this.bookingId,
    this.advocateName = '',
    this.refundStatus,
  });

  factory PaymentReceipt.fromJson(Map<String, dynamic> json) {
    final advocate = Json.pick(json, const ['advocate']);
    return PaymentReceipt(
      transactionId: Json.string(json, const ['transaction_id', 'tran_id', 'id']),
      status: Json.string(json, const ['status']),
      total: Json.number(json, const ['total', 'amount']),
      method: Json.stringOrNull(json, const ['method', 'payment_method', 'card_type']),
      paidAt: Json.date(json, const ['paid_at', 'created_at']),
      bookingId: Json.stringOrNull(json, const ['booking_id']),
      advocateName: advocate is Map
          ? Json.string(Map<String, dynamic>.from(advocate), const ['name'])
          : (advocate?.toString() ?? Json.string(json, const ['advocate_name'])),
      refundStatus: Json.stringOrNull(json, const ['refund_status']),
    );
  }
}
