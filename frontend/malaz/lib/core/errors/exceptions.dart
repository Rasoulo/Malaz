
/// Represents errors that occur during data fetching or processing.
// class ServerException implements Exception {
//   final String? message;
//   ServerException([this.message]);
//   @override
//   String toString() => 'ServerException: ${message ?? ''}';
// }
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ServerException({
    required this.message,
    this.statusCode,
    this.errors,
  });
}
/// Represents errors that occur when there is no internet connection.
class NetworkException implements Exception {}

/// Represents errors that occur when there is no cached data available.
class CacheException implements Exception {
  final String? message;
  CacheException([this.message]);
  @override
  String toString() => 'CacheException: ${message ?? ''}';
}

/// Can be used for other general exceptions.
class GeneralException implements Exception {}

class UnauthenticatedException implements Exception {
  final String message;
  UnauthenticatedException(
      {this.message = 'Session expired, please login again'}); /// TODO: translate
}

/// This exception appears when the user is in a pending state,
/// meaning an account with that username and password already exists but has not yet been approved by the admin.
class InvalidCredentialsException implements Exception {
  final String? message;
  InvalidCredentialsException([this.message]);
  @override
  String toString() => 'InvalidCredentialsException: ${message ?? ''}';
}

/// This exception appears when there is no account with that number entered by the user.
class PhoneNotFoundException implements Exception {
  final String? message;
  PhoneNotFoundException([this.message]);
  @override
  String toString() => 'PhoneNotFoundException: ${message ?? ''}';
}

/// This exception appears when the password for the accompanying number is incorrect.
class WrongPasswordException implements Exception {
  final String? message;
  WrongPasswordException([this.message]);
  @override
  String toString() => 'WrongPasswordException: ${message ?? ''}';
}

class PendingApprovalException implements Exception {
  final String message;
  PendingApprovalException(this.message);
}