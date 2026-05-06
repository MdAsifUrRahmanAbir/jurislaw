class SendOtpModel {
  final String message;
  final Data data;

  SendOtpModel({
    required this.message,
    required this.data,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) => SendOtpModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  final String phone;

  Data({
    required this.phone,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    phone: json["phone"],
  );
}
