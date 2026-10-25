/// Minimal, core-level identity for "who is logged in" — display fields
/// every screen might need (name/avatar in an app bar, profile screen,
/// etc.), independent of any single feature's richer API response shape.
/// Feature-level models (e.g. features/login/data/models/user_model.dart)
/// map their raw API response into this before handing it to
/// [AuthSessionController], keeping core/ free of feature imports.
class AppUser {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? profilePhoto;
  final bool isProfileComplete;
  final String? division;
  final String? district;
  final String? upazila;
  final String? village;

  const AppUser({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.profilePhoto,
    this.isProfileComplete = false,
    this.division,
    this.district,
    this.upazila,
    this.village,
  });

  /// `Kaliganj, Gazipur, Dhaka` — whatever parts are known.
  String get addressLine =>
      [village, upazila, district, division].where((e) => e != null && e.isNotEmpty).join(', ');

  AppUser copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? profilePhoto,
    bool? isProfileComplete,
    String? division,
    String? district,
    String? upazila,
    String? village,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      division: division ?? this.division,
      district: district ?? this.district,
      upazila: upazila ?? this.upazila,
      village: village ?? this.village,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String?,
        profilePhoto: json['profilePhoto'] as String?,
        isProfileComplete: json['isProfileComplete'] as bool? ?? false,
        division: json['division'] as String?,
        district: json['district'] as String?,
        upazila: json['upazila'] as String?,
        village: json['village'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'profilePhoto': profilePhoto,
        'isProfileComplete': isProfileComplete,
        'division': division,
        'district': district,
        'upazila': upazila,
        'village': village,
      };
}
