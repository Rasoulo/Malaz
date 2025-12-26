import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';

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