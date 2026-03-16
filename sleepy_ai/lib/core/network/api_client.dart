import 'package:dio/dio.dart';
import 'package:sleepy_ai/core/network/api_constants.dart';
import 'package:sleepy_ai/core/network/interceptors/auth_interceptor.dart';
import 'package:sleepy_ai/core/network/interceptors/logging_interceptor.dart';
import 'package:sleepy_ai/core/network/interceptors/error_interceptor.dart';

/// Merkezi Dio istemcisi.
/// Tüm API çağrıları bu sınıf üzerinden yapılır.
/// Repository katmanı doğrudan bu sınıfı kullanır.
class ApiClient {
  ApiClient({
    required this.authInterceptor,
    required this.loggingInterceptor,
    required this.errorInterceptor,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeoutMs,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeoutMs,
        ),
        sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeoutMs),
        headers: {
          ApiConstants.headerContentType: 'application/json',
          ApiConstants.headerAccept: 'application/json',
          ApiConstants.headerPlatform: 'android',
          ApiConstants.headerAppVersion: '1.0.0',
        },
        responseType: ResponseType.json,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _dio.interceptors.addAll([
      authInterceptor,
      errorInterceptor,
      loggingInterceptor,
    ]);
  }

  late final Dio _dio;
  final AuthInterceptor authInterceptor;
  final LoggingInterceptor loggingInterceptor;
  final ErrorInterceptor errorInterceptor;

  /// GET isteği gönderir.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// POST isteği gönderir.
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// PUT isteği gönderir.
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.put<T>(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// DELETE isteği gönderir.
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.delete<T>(
      path,
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
