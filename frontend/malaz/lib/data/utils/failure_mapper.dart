import 'package:path/path.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../l10n/app_localizations.dart';

class FailureMapper {
  static Failure map(dynamic exception) {
    if (exception is NetworkException) {
      return NetworkFailure();
    }
    else if (exception is ServerException) {
      return ServerFailure(exception.message);
    }
    else if (exception is UnauthenticatedException) {
      return UnauthenticatedFailure(exception.message);
    } else {
      return UnexpectedFailure('Something went wrong');
    }
  }
}