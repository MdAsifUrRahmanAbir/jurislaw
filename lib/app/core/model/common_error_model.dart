class CommonErrorModel {
  final String message;

  CommonErrorModel({
    required this.message,
  });

  factory CommonErrorModel.fromJson(Map<String, dynamic> json) => CommonErrorModel(
    message: json["message"],
  );
}
