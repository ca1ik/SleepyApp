import 'package:equatable/equatable.dart';

/// Uygulamada hata yonetimi icin temel sinif.
/// Either<Failure, Success> pattern ile kullanilir.
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
  const NetworkFailure([String message = 'Internet baglantisi yok.'])
      : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Yerel veri okuma hatasi.'])
      : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(
      [String message = 'Oturumunuz sona erdi. Lutfen tekrar giris yapin.'])
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
      [String message = 'Beklenmeyen bir hata olustu. Lutfen tekrar deneyin.'])
      : super(message);
}
