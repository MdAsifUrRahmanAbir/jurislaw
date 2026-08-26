class LawyerFilterState {
  final String area;
  final String location;
  final int minExperience;
  final double minRating;
  final double maxFee;

  const LawyerFilterState({
    this.area = 'All',
    this.location = 'All',
    this.minExperience = 0,
    this.minRating = 0,
    this.maxFee = 10000,
  });

  bool get isActive => area != 'All' || location != 'All' || minExperience > 0;

  LawyerFilterState copyWith({String? area, String? location, int? minExperience, double? minRating, double? maxFee}) {
    return LawyerFilterState(
      area: area ?? this.area,
      location: location ?? this.location,
      minExperience: minExperience ?? this.minExperience,
      minRating: minRating ?? this.minRating,
      maxFee: maxFee ?? this.maxFee,
    );
  }
}
