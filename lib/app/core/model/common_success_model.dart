class CommonSuccessModel {
  final String message;

  CommonSuccessModel({
    required this.message,
  });

  factory CommonSuccessModel.fromJson(Map<String, dynamic> json) => CommonSuccessModel(
    message: json["message"],
  );
}
