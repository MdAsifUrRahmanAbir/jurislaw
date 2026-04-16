class Lawyer {
  final String id;
  final String name;
  final String photo;
  final String specialty;
  final int experience;
  final String location;
  final double rating;
  final int reviewsCount;
  final String bio;
  final List<String> specialties;
  final double fee;
  final List<String> practiceAreas;
  final List<Map<String, dynamic>> reviews;
  final String education;
  final String barEnrollment;
  final List<String> languages;
  final String successRate;
  final String availability;

  Lawyer({
    required this.id,
    required this.name,
    required this.photo,
    required this.specialty,
    required this.experience,
    required this.location,
    required this.rating,
    required this.reviewsCount,
    this.bio = '',
    this.specialties = const [],
    this.fee = 0.0,
    this.practiceAreas = const [],
    this.reviews = const [],
    this.education = '',
    this.barEnrollment = '',
    this.languages = const [],
    this.successRate = '',
    this.availability = 'Available Today',
  });
}
