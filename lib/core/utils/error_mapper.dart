import '../network/api_exception.dart';

/// Central place to turn any caught error into a user-facing message.
/// Use this instead of catching ApiException directly in every controller.
String getErrorMessage(Object error) {
  if (error is ApiException) {
    if (error.statusCode == 422) return error.firstFieldError ?? error.message;
    return error.message;
  }
  return 'Something went wrong. Please try again.';
}
