import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sleepy_ai/core/error/failures.dart';
import 'package:sleepy_ai/shared/models/entities.dart';

/// Auth repository interface.
/// Mock implementation kullanımda — Firebase bağlandığında FirebaseAuthRepository
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

/// Firebase Auth implementasyonu (google-services.json olmadan mock çalışır)
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return const Right(null);
      return Right(_mapUser(user));
    } catch (e) {
      return Left(AuthFailure('Kullanici bilgisi alinamadi: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(_mapUser(credential.user!));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Left(UnknownFailure('Giris yapilirken hata: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(displayName);
      return Right(_mapUser(credential.user!));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    } catch (e) {
      return Left(UnknownFailure('Kayit sirasinda hata: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordReset({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(_mapFirebaseError(e.code)));
    }
  }

  @override
  Future<void> logout() => _firebaseAuth.signOut();

  UserEntity _mapUser(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'Kullanici',
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime,
    );
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Bu e-posta ile kayitli kullanici bulunamadi.';
      case 'wrong-password':
        return 'Sifre yanlis. Lutfen tekrar deneyin.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullaniliyor.';
      case 'weak-password':
        return 'Sifre en az 6 karakter olmalidir.';
      case 'invalid-email':
        return 'Gecersiz e-posta adresi.';
      case 'too-many-requests':
        return 'Cok fazla deneme. Lutfen bekleyin.';
      case 'network-request-failed':
        return 'Internet baglantisi yok.';
      default:
        return 'Kimlik dogrulama hatasi: $code';
    }
  }
}
