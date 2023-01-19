import 'dart:developer';
import 'dart:io';

import 'package:great_quran/data/remote/exceptions/exceptions.dart';
import 'package:great_quran/data/remote/exceptions/handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Dio Instance Provider
final _dioProvider = Provider<Dio>(
  (ref) => Dio()
    ..options.connectTimeout = 7000
    ..options.receiveTimeout = 7000,
);

class RemoteClient {
  static final provider = Provider<RemoteClient>((ref) {
    final dio = ref.read(_dioProvider);

    //* Interceptors
    dio.interceptors.add(InterceptorsWrapper(onError: (error, handler) {
      log('Error Intercepted',
          name: 'DIO Error Interceptor', error: "Api Error");
      log('''
            Intercepted an error on api request
              # Request path: ${error.requestOptions.path}
              # Error Message: ${error.message}
              # Response: ${error.response?.data}
              # Request Injected Queries: ${error.requestOptions.queryParameters}
              # Request Headers: ${error.requestOptions.headers}''',
          error: "Dio Client");
      return handler.reject(error);
    }));

    return RemoteClient(dio);
  });

  // dio instance
  final Dio _dio;

  // injecting dio instance
  RemoteClient(this._dio);

  // Get:
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      log(
        response.data,
        name: 'Enagma',
      );
      return response.handle();
    } on SocketException {
      throw NoConnectionException();
    } catch (e) {
      throw FetchDataException();
    }
  }

  // Post:
  Future<dynamic> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.handle();
    } on SocketException {
      throw NoConnectionException();
    } catch (e) {
      throw FetchDataException();
    }
  }

  // Put:
  Future<dynamic> put(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.handle();
    } on SocketException {
      throw NoConnectionException();
    } catch (e) {
      throw FetchDataException();
    }
  }

  // Patch:
  Future<dynamic> patch(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.handle();
    } on SocketException {
      throw NoConnectionException();
    } catch (e) {
      throw FetchDataException();
    }
  }

  // Delete:
  Future<dynamic> delete(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.handle();
    } on SocketException {
      throw NoConnectionException();
    } catch (e) {
      throw FetchDataException();
    }
  }

  // API Headers
  Map<String, String> headersWithToken(String? authToken) => {
        HttpHeaders.authorizationHeader: 'Bearer $authToken',
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json",
      };

  Map<String, String> jsonHeaders() => {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.acceptHeader: "application/json"
      };
}
