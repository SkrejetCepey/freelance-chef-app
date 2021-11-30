import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:freelance_chef_app/models/interfaces/jsonable.dart';
import 'package:freelance_chef_app/models/mixins/accessible_by_jwt_tokens.dart';

import 'api.dart';

class JWTDio {
  late final Dio _dio;
  late AccessibleByJWTTokens? _accessibleByJWTTokens;

  JWTDio(AccessibleByJWTTokens? accessibleByJWTTokens, [BaseOptions? options]) {
    _accessibleByJWTTokens = accessibleByJWTTokens;
    _dio = Dio(options);
  }

  bool isConnectionSupportJwt() {
    return _accessibleByJWTTokens != null;
  }

  void updateAccessibleByJWTTokens(AccessibleByJWTTokens accessibleByJWTTokens) {
    _accessibleByJWTTokens = accessibleByJWTTokens;
  }

  Future<void> _middlewareAccessErrorsHandler(DioError e) async {
    if (_accessibleByJWTTokens == null) {
      return;
    }

    switch (e.response!.statusCode) {
      case 401:
        var tokens = await _refreshTokens(_accessibleByJWTTokens!);
        _accessibleByJWTTokens!.setTokensByMap(tokens);
        return;
    }
    throw e;
  }

  Future<Map<String, dynamic>> _refreshTokens(AccessibleByJWTTokens obj) async {
    try {
      var request = await _dio.postUri(Uri.parse(API.REFRESH),
          data: json.encode({'RefreshToken': obj.refreshToken}),
          options: Options(headers: {'content-type': 'application/json'}));

      return request.data as Map<String, dynamic>;
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<Response<dynamic>>? getUri(
    Uri uri, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return _dio.getUri(uri,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<dynamic>>? postUriObject(
    Uri uri,
    Jsonable jsonable, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    options = Options(headers: {
      'content-type': 'application/json'
    });
    return _dio.postUri(uri,
        data: jsonable.getJson(),
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<dynamic>>? postUriObjectWithValidateByTokens(
    Uri uri,
    Jsonable jsonable,
    AccessibleByJWTTokens obj, {
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    if (options == null) {
      options = Options(headers: {
        'content-type': 'application/json',
        "Authorization": "Bearer ${obj.accessToken}"
      });
    } else if (options.headers == null) {
      options.headers = {
        'content-type': 'application/json',
        "Authorization": "Bearer ${obj.accessToken}"
      };
    } else if (options.headers!["Authorization"] == null) {
      options.headers!["Authorization"] = "Bearer ${obj.accessToken}";
    }

    return postUriObject(uri, jsonable,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<dynamic>>? postUri(
    Uri uri, {
    Options? options,
    dynamic data,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) {
    return _dio.postUri(uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<dynamic>>? postUriWithValidateByTokens(Uri uri,
      {dynamic data,
      Options? options,
      CancelToken? cancelToken,
      void Function(int, int)? onSendProgress,
      void Function(int, int)? onReceiveProgress,
      required AccessibleByJWTTokens obj}) {
    if (options == null) {
      options = Options(headers: {
        'content-type': 'application/json',
        "Authorization": "Bearer ${obj.accessToken}"
      });
    } else if (options.headers == null) {
      options.headers = {
        'content-type': 'application/json',
        "Authorization": "Bearer ${obj.accessToken}"
      };
    } else if (options.headers!["Authorization"] == null) {
      options.headers!["Authorization"] = "Bearer ${obj.accessToken}";
    }

    try {
      return _dio.postUri(uri,
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
    } on DioError catch (e) {
      _middlewareAccessErrorsHandler(e);
    }
  }
}
