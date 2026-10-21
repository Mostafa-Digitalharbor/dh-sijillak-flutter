import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Tells the backend which language to answer in and which platform asks.
class LanguageInterceptor extends Interceptor {
  LanguageInterceptor(this._languageCode);

  static const acceptLanguageHeader = 'Accept-Language';
  static const platformHeader = 'X-App-Platform';

  final String Function() _languageCode;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[acceptLanguageHeader] = _languageCode();
    options.headers[platformHeader] = defaultTargetPlatform.name;
    handler.next(options);
  }
}
