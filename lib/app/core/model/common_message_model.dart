class CommonMessageModel {
  final String message;

  CommonMessageModel({
    required this.message,
  });

  factory CommonMessageModel.fromJson(Map<String, dynamic> json) => CommonMessageModel(
    message: json["message"],
  );
}
