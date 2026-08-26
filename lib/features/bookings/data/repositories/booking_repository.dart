import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) => BookingRepository());

/// No bookings API exists yet — ukil-chaai-client's own bookings screen has
/// no controller or API call either, just a static placeholder list. This
/// returns local dummy data with the same shape a real endpoint response
/// would have, so a real `fetchBookings()` implementation can replace the
/// body here later without touching any caller.
class BookingRepository {
  List<BookingModel> fetchBookings() => [
        BookingModel(id: '1', personName: 'Laura Lim', dateTime: DateTime(2026, 4, 15, 10, 0), status: BookingStatus.upcoming),
        BookingModel(id: '2', personName: 'Arafat Karim', dateTime: DateTime(2026, 4, 18, 14, 30), status: BookingStatus.upcoming),
        BookingModel(id: '3', personName: 'Jhon Smith', dateTime: DateTime(2026, 3, 2, 9, 0), status: BookingStatus.completed),
        BookingModel(id: '4', personName: 'Mitu Rahman', dateTime: DateTime(2026, 2, 20, 11, 0), status: BookingStatus.completed),
        BookingModel(id: '5', personName: 'Sabbir Hossain', dateTime: DateTime(2026, 1, 30, 16, 0), status: BookingStatus.completed),
        BookingModel(id: '6', personName: 'Nusrat Jahan', dateTime: DateTime(2026, 1, 12, 13, 0), status: BookingStatus.completed),
        BookingModel(id: '7', personName: 'Kamal Uddin', dateTime: DateTime(2025, 12, 28, 10, 0), status: BookingStatus.completed),
      ];
}
