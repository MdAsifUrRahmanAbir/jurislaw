enum BookingStatus { upcoming, completed }

class BookingModel {
  final String id;
  final String personName;
  final DateTime dateTime;
  final BookingStatus status;

  const BookingModel({
    required this.id,
    required this.personName,
    required this.dateTime,
    required this.status,
  });
}
