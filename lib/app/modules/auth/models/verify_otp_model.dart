class VerifyOtpModel {
  final String message;
  final Data data;

  VerifyOtpModel({
    required this.message,
    required this.data,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) => VerifyOtpModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  final User user;
  final bool isProfileComplete;
  final String token;

  Data({
    required this.user,
    required this.isProfileComplete,
    required this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    user: User.fromJson(json["user"]),
    isProfileComplete: json["isProfileComplete"],
    token: json["token"],
  );
}

class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final dynamic emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String division;
  final String district;
  final String upazila;
  final String villageMohalla;
  final String isProfileComplete;
  final String profilePhoto;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.division,
    required this.district,
    required this.upazila,
    required this.villageMohalla,
    required this.isProfileComplete,
    required this.profilePhoto,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"].toString(),
    name: json["name"] ?? "",
    phone: json["phone"],
    email: json["email"] ?? "",
    emailVerifiedAt: json["email_verified_at"] ?? "",
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    division: json["division"] ?? "",
    district: json["district"] ?? "",
    upazila: json["upazila"] ?? "",
    villageMohalla: json["village_mohalla"] ?? "",
    isProfileComplete: json["is_profile_complete"],
    profilePhoto: json["profile_photo"] ?? "",
  );
}
