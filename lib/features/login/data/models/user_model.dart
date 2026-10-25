import '../../../../core/session/app_user.dart';
import '../../../../core/utils/json_utils.dart';

class UserModel {
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

  UserModel({
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

  /// [photoUrl] is the separate `profile_photo_url` that GET /profile sends
  /// next to `user` — it wins over the raw stored path inside `user`.
  factory UserModel.fromJson(Map<String, dynamic> json, {String? photoUrl}) {
    return UserModel(
      id: Json.string(json, const ['id']),
      name: Json.string(json, const ['name']),
      phone: Json.string(json, const ['phone', 'mobile']),
      email: Json.stringOrNull(json, const ['email']),
      profilePhoto: photoUrl ?? Json.stringOrNull(json, const ['profile_photo_url', 'profile_photo', 'photo_url', 'avatar']),
      isProfileComplete: Json.boolean(json, const ['is_profile_complete', 'isProfileComplete']),
      division: Json.stringOrNull(json, const ['division']),
      district: Json.stringOrNull(json, const ['district']),
      upazila: Json.stringOrNull(json, const ['upazila']),
      village: Json.stringOrNull(json, const ['village_mohalla', 'village']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'profile_photo': profilePhoto,
        'is_profile_complete': isProfileComplete,
        'division': division,
        'district': district,
        'upazila': upazila,
        'village_mohalla': village,
      };

  AppUser toAppUser() => AppUser(
        id: id,
        name: name,
        phone: phone,
        email: email,
        profilePhoto: profilePhoto,
        isProfileComplete: isProfileComplete,
        division: division,
        district: district,
        upazila: upazila,
        village: village,
      );
}
