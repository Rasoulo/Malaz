
import 'package:equatable/equatable.dart';

/// [Failure]
///
/// A base class for all failures. Failures are part of the domain layer.
/// the main purpose of it is to handle all exceptions and convert them to failures
/// [Failure] extends from [Equatable] to make [Failure] objects comparable you
/// can search for it
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents a failure that occurs when communicating with a server.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Represents a failure that occurs when there is no internet connection.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Represents a failure that occurs when accessing cached data.
class OfflineFailure extends Failure {
  const OfflineFailure(super.message);
}

/// Represents other general failures.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure(super.message);
}
