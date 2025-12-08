
import 'package:equatable/equatable.dart';

/// [Failure]
///
/// A base class for all failures. Failures are part of the domain layer.
/// the main purpose of it is to handle all exceptions and convert them to failures
/// [Failure] extends from [Equatable] to make [Failure] objects comparable you
/// can search for it
abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => [];
}

/// Represents a failure that occurs when communicating with a server.
class ServerFailure extends Failure {}

/// Represents a failure that occurs when there is no internet connection.
class NetworkFailure extends Failure {}

/// Represents a failure that occurs when accessing cached data.
class CacheFailure extends Failure {}

/// Represents other general failures.
class GeneralFailure extends Failure {}
