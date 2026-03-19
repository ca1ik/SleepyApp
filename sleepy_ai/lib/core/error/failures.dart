import 'package:equatable/equatable.dart';

/// Base class for error handling in the app.
/// Used with Either<Failure, Success> pattern.
abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});
  final int? statusCode;
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection.'])
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Local data read error.'])
      : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(
      [String message = 'Your session has expired. Please log in again.'])
      : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class PurchaseFailure extends Failure {
  const PurchaseFailure(super.message);
}

class PlatformFailure extends Failure {
  const PlatformFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(
      [String message = 'An unexpected error occurred. Please try again.'])
      : super(message);
}
