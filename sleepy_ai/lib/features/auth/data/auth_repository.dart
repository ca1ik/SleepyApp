import 'package:dartz/dartz.dart';
import 'package:sleepy_ai/core/error/failures.dart';
import 'package:sleepy_ai/shared/models/entities.dart';

/// Auth repository interface.
/// Mock implementation active — when Firebase is ready, FirebaseAuthRepository
/// implements this class, dependency injection stays the same.
abstract class AuthRepository {
  /// Returns the current user. Null if no session.
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Login with email and password.
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  /// New registration.
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Password reset email.
  Future<Either<Failure, void>> sendPasswordReset({required String email});

  /// Sign out.
  Future<void> logout();
}

/// Mock Auth implementation (works locally until Firebase is ready)
/// When Firebase is ready, this class is replaced with FirebaseAuthRepository.
class MockAuthRepository implements AuthRepository {
  static const _mockUser = UserEntity(
    id: 'local-user-001',
    email: 'demo@sleepyapp.com',
    displayName: 'Demo User',
  );

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    return const Right(_mockUser);
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    if (password.length < 6) {
      return Left(AuthFailure('Password must be at least 6 characters.'));
    }
    return Right(_mockUser.copyWith(email: email));
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return Right(_mockUser.copyWith(email: email, displayName: displayName));
  }

  @override
  Future<Either<Failure, void>> sendPasswordReset({
    required String email,
  }) async {
    return const Right(null);
  }

  @override
  Future<void> logout() async {}

  // ignore: unused_element
  String _unused(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      default:
        return 'Authentication error: $code';
    }
  }
}
