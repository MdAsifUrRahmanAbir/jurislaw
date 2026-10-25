import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errors;

  const ApiException({
    required this.message,
    this.statusCode,
    this.errors,
  });

  factory ApiException.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const ApiException(
          message: 'Connection timed out. Please check your internet connection and try again.',
          statusCode: 408,
        );

      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection available.',
          statusCode: 0,
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);

      case DioExceptionType.cancel:
        return const ApiException(
          message: 'Request was cancelled.',
          statusCode: 499,
        );

      case DioExceptionType.badCertificate:
        return const ApiException(
          message: 'Security certificate validation failed.',
          statusCode: 495,
        );

      case DioExceptionType.unknown:
      default:
        return ApiException(
          message: e.message ?? 'An unexpected error occurred. Please try again.',
          statusCode: 500,
        );
    }
  }

  static ApiException _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    String message = 'Server error occurred.';
    dynamic errors;

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? data['msg'] ?? 'Server error ($statusCode)';
      errors = data['errors'] ?? data['data'];
    } else if (data is String && data.isNotEmpty) {
      message = data;
    }

    switch (statusCode) {
      case 400:
        message = message != 'Server error occurred.' ? message : 'Bad request.';
        break;
      case 401:
        message = message != 'Server error occurred.' ? message : 'Unauthorized. Please login again.';
        break;
      case 403:
        message = message != 'Server error occurred.' ? message : 'Access forbidden.';
        break;
      case 404:
        message = message != 'Server error occurred.' ? message : 'Requested resource not found.';
        break;
      case 422:
        message = message != 'Server error occurred.' ? message : 'Validation failed.';
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        message = 'Internal server error. Please try again later.';
        break;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      errors: errors,
    );
  }

  /// Machine-readable `data.code` the API sends with some 400/403 errors
  /// (e.g. `payment_required`, `not_confirmed`, `already_closed`).
  String? get code {
    final source = errors;
    if (source is Map && source['code'] != null) return source['code'].toString();
    return null;
  }

  /// First field-level validation message from a 422 body, if any.
  String? get firstFieldError {
    final source = errors;
    if (source is! Map) return null;
    for (final value in source.values) {
      if (value is List && value.isNotEmpty) return value.first.toString();
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}