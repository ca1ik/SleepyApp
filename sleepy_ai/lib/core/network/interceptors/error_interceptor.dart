import 'package:dio/dio.dart';
import 'package:sleepy_ai/core/error/failures.dart';

/// Converts Dio error responses to Failure objects.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = _mapDioError(err);
    // Attach Failure to error extra — repository layer can read it
    handler.next(err.copyWith(error: failure));
  }

  Failure _mapDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkFailure('Connection timed out. Try again.');
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        return _mapStatusCode(error.response?.statusCode);
      case DioExceptionType.cancel:
        return const UnknownFailure('Request cancelled.');
      case DioExceptionType.badCertificate:
        return const ServerFailure('Could not establish secure connection.');
      case DioExceptionType.unknown:
        return const UnknownFailure();
    }
  }

  Failure _mapStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return const ValidationFailure('Invalid request.');
      case 401:
        return const UnauthorizedFailure();
      case 403:
        return const UnauthorizedFailure(
            'You do not have access to this resource.');
      case 404:
        return const ServerFailure('Resource not found.', statusCode: 404);
      case 422:
        return const ValidationFailure('Data validation error.');
      case 429:
        return const ServerFailure(
          'Too many requests. Please wait.',
          statusCode: 429,
        );
      default:
        return ServerFailure(
          'Server error (${statusCode ?? 'unknown'}).',
          statusCode: statusCode,
        );
    }
  }
}
