import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// İstekleri ve yanıtları console'a loglar.
/// Sadece debug modda aktif olmalı.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor()
    : _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 80,
          printEmojis: true,
        ),
      );

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i(
      '[REQUEST] ${options.method} ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Data: ${options.data}',
    );
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.d(
      '[RESPONSE] ${response.statusCode} ${response.requestOptions.uri}\n'
      'Data: ${response.data}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '[ERROR] ${err.type} ${err.requestOptions.uri}\n'
      'Message: ${err.message}\n'
      'Response: ${err.response?.data}',
      error: err,
    );
    handler.next(err);
  }
}
