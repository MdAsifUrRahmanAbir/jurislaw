import 'package:flutter_test/flutter_test.dart';
import 'package:ukil_chaai/core/network/paginated_response.dart';
import 'package:ukil_chaai/features/bookings/data/models/booking_model.dart';
import 'package:ukil_chaai/features/home/data/models/dashboard_model.dart';
import 'package:ukil_chaai/features/lawyer_list/data/models/advocate_model.dart';
import 'package:ukil_chaai/features/payments/data/models/payment_models.dart';
import 'package:ukil_chaai/features/session/data/models/session_models.dart';

// Sample bodies follow the field names in the Juris Law Mobile API
// Reference. Replace them with real responses once they are captured.
void main() {
  test('advocate list with meta paginates', () {
    final page = PaginatedResponse.fromBody(
      {
        'data': [
          {'id': 7, 'name': 'Raphaelle Stracke', 'district': 'Dhaka', 'division': 'Dhaka', 'practice_areas': ['Criminal Law', 'Tax Law'], 'experience_years': '29', 'starting_price': null},
        ],
        'meta': {'current_page': 1, 'last_page': 3, 'total': 40},
      },
      AdvocateSummary.fromJson,
      perPage: 15,
    );
    expect(page.items.single.name, 'Raphaelle Stracke');
    expect(page.items.single.practiceAreas, ['Criminal Law', 'Tax Law']);
    expect(page.items.single.experienceYears, 29);
    expect(page.items.single.hasOpenSlots, isFalse);
    expect(page.hasMore, isTrue);
  });

  test('laravel nested paginator is understood', () {
    final page = PaginatedResponse.fromBody(
      {
        'data': {'data': [{'id': 1, 'status': 'confirmed', 'advocate': {'id': 2, 'name': 'Adv. X'}}], 'current_page': 2, 'last_page': 2},
      },
      BookingModel.fromJson,
    );
    expect(page.items.single.isConfirmed, isTrue);
    expect(page.items.single.advocate.name, 'Adv. X');
    expect(page.hasMore, isFalse);
  });

  test('advocate detail carries inline slots', () {
    final detail = AdvocateDetail.fromData({
      'id': 7,
      'name': 'Raphaelle Stracke',
      'has_more_slots': true,
      'slots': [
        {'id': 11, 'date': '2026-11-02', 'start_time': '10:00', 'end_time': '10:30', 'price': '1500.00', 'session_type': 'chat'},
      ],
    });
    expect(detail.slots.single.price, 1500);
    expect(detail.slots.single.startsAt, DateTime(2026, 11, 2, 10, 0));
    expect(detail.hasMoreSlots, isTrue);
  });

  test('booking fields from A5.1', () {
    final booking = BookingModel.fromJson({
      'id': 5,
      'status': 'reschedule_offered',
      'status_label': 'New time proposed',
      'payment_status': 'paid',
      'amount': 1650,
      'can_cancel': true,
      'cancel_blocked': null,
      'refund': {'status': 'pending', 'amount': 1650},
      'declined_slot_ids': [3, 4],
    });
    expect(booking.needsResponse, isTrue);
    expect(booking.isPaid, isTrue);
    expect(booking.refund!.isPending, isTrue);
    expect(booking.declinedSlotIds, ['3', '4']);
  });

  test('dashboard stats/today/upcoming', () {
    final dashboard = DashboardModel.fromData({
      'stats': {'upcoming': 2, 'completed': 5},
      'today': [],
      'upcoming': [
        {'id': 1, 'status': 'confirmed'},
        {'id': 2, 'status': 'reschedule_offered', 'needs_response': true},
      ],
    });
    expect(dashboard.stats.map((s) => s.label), ['Upcoming', 'Completed']);
    expect(dashboard.needsResponse.single.id, '2');
  });

  test('checkout quote and payment session', () {
    final summary = CheckoutSummary.fromData({
      'quote': {'advocate_fee': 1500, 'platform_charge': 150, 'total': 1650},
      'booking': {'id': 5, 'reserved_until': '2026-10-25T10:15:00Z'},
      'gateway_available': true,
    }, '5');
    expect(summary.total, 1650);
    expect(summary.platformCharge, 150);
    expect(summary.reservedUntil, isNotNull);

    final session = PaymentSession.fromData({
      'transaction_id': 'JL123',
      'gateway_url': 'https://sandbox.sslcommerz.com/x',
      'return_urls': {'success': 'https://a/success', 'fail': 'https://a/fail', 'cancel': 'https://a/cancel'},
    });
    expect(session.returnUrls, hasLength(3));
  });

  test('chat messages and is_open', () {
    final page = MessagesPage.fromBody({
      'data': [{'id': 9, 'message': '<b>hi</b>', 'is_me': 1}],
      'is_open': false,
    });
    expect(page.messages.single.isMe, isTrue);
    expect(page.messages.single.message, '<b>hi</b>');
    expect(page.isOpen, isFalse);
  });
}
