import 'package:equatable/equatable.dart';
import 'package:sleepy_ai/shared/models/entities.dart';

/// AuthBloc state'leri
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// İlk durum — auth henüz kontrol edilmedi
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Yükleniyor
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Oturum açık
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});
  final UserEntity user;

  @override
  List<Object> get props => [user];
}

/// Oturum yok / çıkış yapıldı
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Hata
class AuthError extends AuthState {
  const AuthError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

/// Şifremi unuttum e-postası gönderildi
class AuthPasswordResetSent extends AuthState {
  const AuthPasswordResetSent({required this.email});
  final String email;

  @override
  List<Object> get props => [email];
}
