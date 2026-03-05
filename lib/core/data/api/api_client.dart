import 'package:dio/dio.dart';
import '../../constants/api_constants.dart';
import 'api_interceptor.dart';

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      queryParameters: {'apiKey': ApiConstants.apiKey},
      headers: {'Content-Type': ApiConstants.contentType},
      validateStatus: (status) {
        // Accept all status codes and handle them in the interceptor
        return status != null && status < 500;
      },
    ),
  );

  // Add interceptors
  dio.interceptors.addAll([
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
      error: true,
      logPrint: (object) {
        // You can use a logger package here in production
        print('[DIO] $object');
      },
    ),
    ErrorInterceptor(),
  ]);

  return dio;
}
