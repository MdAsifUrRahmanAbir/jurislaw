class LawyerReview {
  final String name;
  final double rating;
  final String comment;
  final String date;

  const LawyerReview({required this.name, required this.rating, required this.comment, required this.date});
}

/// Ported from ukil-chaai's `Lawyer` model (app/data/models/lawyer_model.dart).
/// The source app has no lawyer-listing API yet — this is dummy/static data
/// end-to-end (see [lawyersProvider]); wire a real repository call here
/// once that endpoint exists.
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
  final double fee;
  final List<String> practiceAreas;
  final List<LawyerReview> reviews;
  final String education;
  final String barEnrollment;
  final List<String> languages;
  final String successRate;
  final String availability;

  const Lawyer({
    required this.id,
    required this.name,
    required this.photo,
    required this.specialty,
    required this.experience,
    required this.location,
    required this.rating,
    required this.reviewsCount,
    this.bio = '',
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
