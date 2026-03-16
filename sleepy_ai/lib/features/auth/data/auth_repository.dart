import 'package:dartz/dartz.dart';
import 'package:sleepy_ai/core/error/failures.dart';
import 'package:sleepy_ai/shared/models/entities.dart';

/// Auth repository interface.
/// Mock implementation aktif — Firebase hazır olduğunda FirebaseAuthRepository
/// bu sınıfı implemente eder, dependency injection değişmeden kalır.
abstract class AuthRepository {
  /// Mevcut kullanıcıyı döndürür. Oturum yoksa null.
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// E-posta ve şifre ile giriş.
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Yeni kayıt.
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Şifre sıfırlama e-postası.
  Future<Either<Failure, void>> sendPasswordReset({required String email});

  /// Çıkış.
  Future<void> logout();
}

/// Mock Auth implementasyonu (Firebase hazır olana kadar yerel çalışır)
/// Firebase hazır olduğunda bu sınıfın yerine FirebaseAuthRepository koyulur.
class MockAuthRepository implements AuthRepository {
  static const _mockUser = UserEntity(
    id: 'local-user-001',
    email: 'demo@sleepyapp.com',
    displayName: 'Demo Kullanici',
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
      return Left(AuthFailure('Sifre en az 6 karakter olmalidir.'));
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
        return 'Bu e-posta ile kayitli kullanici bulunamadi.';
      default:
        return 'Kimlik dogrulama hatasi: $code';
    }
  }
}
