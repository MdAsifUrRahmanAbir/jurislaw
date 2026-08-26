import '../../../../core/session/app_user.dart';

class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? profilePhoto;
  final bool isProfileComplete;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.profilePhoto,
    this.isProfileComplete = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: (json['email'] as String?)?.isEmpty ?? true ? null : json['email'] as String,
      profilePhoto: (json['profile_photo'] as String?)?.isEmpty ?? true ? null : json['profile_photo'] as String,
      isProfileComplete: json['is_profile_complete'] == true || json['is_profile_complete'] == 1 || json['is_profile_complete'] == '1',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'profile_photo': profilePhoto,
        'is_profile_complete': isProfileComplete,
      };

  AppUser toAppUser() => AppUser(
        id: id,
        name: name,
        phone: phone,
        email: email,
        profilePhoto: profilePhoto,
        isProfileComplete: isProfileComplete,
      );
}
