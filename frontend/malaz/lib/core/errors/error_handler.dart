import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:malaz/l10n/app_localizations.dart';
import 'package:path/path.dart';
import '../errors/exceptions.dart';

/// TODO: translate
class ErrorHandler {
  static Exception handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(AppLocalizations.of(context as BuildContext).network_error_message);

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return ServerException(message: AppLocalizations.of(context as BuildContext).request_cancelled_error_message);

      default:
        return ServerException(message: AppLocalizations.of(context as BuildContext).unexpected_error_message);
    }
  }

  static Exception _handleBadResponse(Response? response) {
    if (response == null) return ServerException(message: 'Unknown server error');

    final statusCode = response.statusCode;
    final data = response.data;
    String message = 'Something went wrong';

    if (data is Map && data.containsKey('message')) {
      message = data['message'];
    }

    if (statusCode == 401) {
      return UnauthenticatedException(message);
    }

    if(statusCode == 403) {
      if (message.toLowerCase().contains('does not exist')) {
        return PhoneNotFoundException(message);
      }
    }

    if (statusCode == 422 && data is Map) {
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final firstErrorList = errors[firstKey];
          if (firstErrorList is List && firstErrorList.isNotEmpty) {
            return ServerException(
              message: firstErrorList.first.toString(),
              statusCode: 422,
            );
          }
        }
      }
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerException(message: 'Server internal error', statusCode: 500);
    }

    return ServerException(message: message, statusCode: statusCode);
  }
}