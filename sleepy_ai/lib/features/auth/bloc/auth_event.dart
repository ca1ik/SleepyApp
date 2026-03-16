import 'package:equatable/equatable.dart';

/// AuthBloc eventleri
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Uygulama başlangıcında kullanıcı oturum durumunu kontrol et
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// E-posta ve şifre ile giriş
class LoginWithEmailRequested extends AuthEvent {
  const LoginWithEmailRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// Yeni kayıt
class RegisterWithEmailRequested extends AuthEvent {
  const RegisterWithEmailRequested({
    required this.email,
    required this.password,
    required this.displayName,
  });

  final String email;
  final String password;
  final String displayName;

  @override
  List<Object> get props => [email, password, displayName];
}

/// Şifremi unuttum
class ForgotPasswordRequested extends AuthEvent {
  const ForgotPasswordRequested({required this.email});
  final String email;

  @override
  List<Object> get props => [email];
}

/// Çıkış yap
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Google ile giriş (ileride eklenecek)
class LoginWithGoogleRequested extends AuthEvent {
  const LoginWithGoogleRequested();
}
