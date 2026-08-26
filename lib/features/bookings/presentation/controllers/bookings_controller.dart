import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/booking_model.dart';
import '../../data/repositories/booking_repository.dart';

class BookingsController extends Notifier<List<BookingModel>> {
  @override
  List<BookingModel> build() => ref.read(bookingRepositoryProvider).fetchBookings();

  List<BookingModel> get upcoming => state.where((b) => b.status == BookingStatus.upcoming).toList();
  List<BookingModel> get past => state.where((b) => b.status == BookingStatus.completed).toList();
}

final bookingsControllerProvider = NotifierProvider<BookingsController, List<BookingModel>>(BookingsController.new);
