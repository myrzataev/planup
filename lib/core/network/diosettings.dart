import "dart:async";

import "package:dio/dio.dart";
import "package:flutter/foundation.dart";

class DioSettings {
  DioSettings() {
    unawaited(setup());
  }

  Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://planup.skynet.kg:8000/news/api/",
      contentType: "application/json",
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  Dio dio1 = Dio(
    BaseOptions(
      baseUrl: "http://10.1.2.48:8000/api/",
      contentType: "application/json",
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  Dio dio2 = Dio(
    BaseOptions(
      baseUrl: "http://10.1.2.89:8000/api/",
      contentType: "application/json",
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  Dio dio3 = Dio(
    BaseOptions(
      baseUrl: "http://planup.skynet.kg:8000/planup/uploadhydra/",
      // contentType: "multipart/form-data",
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ),
  );
  Future<void> setup() async {
    final Interceptors interceptors = dio.interceptors;
    final Interceptors interceptors1 = dio1.interceptors;
    final Interceptors interceptors2 = dio2.interceptors;
    final Interceptors interceptors3 = dio3.interceptors;

    interceptors.clear();
    interceptors1.clear();
    interceptors2.clear();
    interceptors3.clear();
    final LogInterceptor logInterceptor = LogInterceptor(
      requestBody: true,
      responseBody: true,
    );

    final QueuedInterceptorsWrapper headerInterceptors =
        QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        return handler.next(options);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        handler.next(error);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) =>
          handler.next(response),
    );
    interceptors.addAll([if (kDebugMode) logInterceptor, headerInterceptors]);
    interceptors1.addAll([if (kDebugMode) logInterceptor, headerInterceptors]);
    interceptors2.addAll([if (kDebugMode) logInterceptor, headerInterceptors]);
    interceptors3.addAll([if (kDebugMode) logInterceptor, headerInterceptors]);
  }
}
