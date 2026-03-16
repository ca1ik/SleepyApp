import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sleepy_ai/core/constants/app_constants.dart';

/// Her isteğe Authorization header ekler.
/// Token süresi dolmuşsa refresh yapar.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: AppStrings.keyAuthToken);
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.headerAuth] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Token yenileme mekanizması buraya gelecek
      // Şimdilik kullanıcıyı logout et
      await _storage.delete(key: AppStrings.keyAuthToken);
      await _storage.delete(key: AppStrings.keyRefreshToken);
    }
    handler.next(err);
  }
}
