import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:great_quran/data/remote/exceptions/exceptions.dart';
import 'package:great_quran/data/remote/exceptions/handler.dart';
import 'package:dio/dio.dart';
import 'package:great_quran/helpers/type_def.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_client.g.dart';

// Dio Instance Provider
@riverpod
Dio _dio(_DioRef ref) {
  return Dio()
    ..options.connectTimeout = const Duration(milliseconds: 7000)
    ..options.receiveTimeout = const Duration(milliseconds: 7000);
}

@riverpod
RemoteClient remoteClient(RemoteClientRef ref) {
  final dio = ref.read(_dioProvider);

  //* Interceptors
  dio.interceptors.add(InterceptorsWrapper(onError: (error, handler) {
    log('Error Intercepted', name: 'DIO Error Interceptor', error: "Api Error");
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
}

class RemoteClient {
  const RemoteClient(this._dio);
  final Dio _dio;

  // Get:
  Future<dynamic> get(
    String uri, {
    JSON? queryParameters,
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

      return response.handle();
    } on SocketException {
      throw NoConnectionException();
    } catch (e, s) {
      debugPrint("Remote Client Error in GET: $uri");
      debugPrint("Error ${e.toString()}");
      debugPrint("Error Stack ${s.toString()}");

      throw FetchDataException();
    }
  }

  // Post:
  Future<dynamic> post(
    String uri, {
    dynamic data,
    JSON? queryParameters,
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
    } catch (e, s) {
      debugPrint("Remote Client Error in POST: $uri");
      debugPrint("Error ${e.toString()}");
      debugPrint("Error Stack ${s.toString()}");
      throw FetchDataException();
    }
  }

  // Put:
  Future<dynamic> put(
    String uri, {
    dynamic data,
    JSON? queryParameters,
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
    } catch (e, s) {
      debugPrint("Remote Client Error in PUT: $uri");
      debugPrint("Error ${e.toString()}");
      debugPrint("Error Stack ${s.toString()}");
      throw FetchDataException();
    }
  }

  // Patch:
  Future<dynamic> patch(
    String uri, {
    dynamic data,
    JSON? queryParameters,
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
    } catch (e, s) {
      debugPrint("Remote Client Error in PATCH: $uri");
      debugPrint("Error ${e.toString()}");
      debugPrint("Error Stack ${s.toString()}");
      throw FetchDataException();
    }
  }

  // Delete:
  Future<dynamic> delete(
    String uri, {
    dynamic data,
    JSON? queryParameters,
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
    } catch (e, s) {
      debugPrint("Remote Client Error in DELETE: $uri");
      debugPrint("Error ${e.toString()}");
      debugPrint("Error Stack ${s.toString()}");
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
