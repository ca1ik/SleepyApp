import 'package:dio/dio.dart';
import 'package:sleepy_ai/core/error/failures.dart';

/// Dio hata yanıtlarını Failure nesnelerine dönüştürür.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapDioError(err);
    // Failure'ı error extra'sına ekle — repository katmanı okuyabilir
    handler.next(err.copyWith(error: failure));
  }

  Failure _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkFailure('Baglanti zaman asimi. Tekrar deneyin.');
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        return _mapStatusCode(error.response?.statusCode);
      case DioExceptionType.cancel:
        return const UnknownFailure('Istek iptal edildi.');
      case DioExceptionType.badCertificate:
        return const ServerFailure('Guvenli baglanti kurulamadi.');
      case DioExceptionType.unknown:
        return const UnknownFailure();
    }
  }

  Failure _mapStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const ValidationFailure('Gecersiz istek.');
      case 401:
        return const UnauthorizedFailure();
      case 403:
        return const UnauthorizedFailure('Bu kaynaga erisim izniniz yok.');
      case 404:
        return const ServerFailure('Kaynak bulunamadi.', statusCode: 404);
      case 422:
        return const ValidationFailure('Veri dogrulama hatasi.');
      case 429:
        return const ServerFailure(
          'Cok fazla istek. Lutfen bekleyin.',
          statusCode: 429,
        );
      default:
        return ServerFailure(
          'Sunucu hatasi (${statusCode ?? 'bilinmiyor'}).',
          statusCode: statusCode,
        );
    }
  }
}
