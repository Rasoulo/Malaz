
import 'package:equatable/equatable.dart';

/// [Failure]
///
/// A base class for all failures. Failures are part of the domain layer.
/// the main purpose of it is to handle all exceptions and convert them to failures
/// [Failure] extends from [Equatable] to make [Failure] objects comparable you
/// can search for it
abstract class Failure extends Equatable {
  final String? message;
  const Failure([this.message]);

  @override
  List<Object?> get props => [message];
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
class GeneralFailure extends Failure {
  const GeneralFailure([super.message]);
}

/// This failure appears when the user is in a pending state,
/// meaning an account with that username and password already exists but has not yet been approved by the admin.
class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(super.message);
}

/// This exception appears when there is no account with that number entered by the user.
class PhoneNotFoundFailure extends Failure {
  const PhoneNotFoundFailure([super.message]);
}

/// This exception appears when the password for the accompanying number is incorrect.
class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure(super.message);
}

class PendingApprovalFailure extends Failure {
  const PendingApprovalFailure()
      : super('Wait until approved by the officials');
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}