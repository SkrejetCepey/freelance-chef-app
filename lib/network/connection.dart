import 'dart:async';

import 'package:dio/dio.dart';
import 'package:freelance_chef_app/models/mixins/accessible_by_jwt_tokens.dart';
import 'package:freelance_chef_app/models/order.dart';
import 'package:freelance_chef_app/models/user.dart';
import 'package:freelance_chef_app/network/jwt_dio.dart';

import 'api.dart';
import 'connection_error.dart';

class Connection {
  late JWTDio _jwtDio;
  late StreamController tokensChangesJwtDio;
  final BaseOptions baseOptions =
      BaseOptions(connectTimeout: 15000, receiveTimeout: 15000);

  Connection(AccessibleByJWTTokens? c) {
    _jwtDio = JWTDio(c, baseOptions);
    tokensChangesJwtDio = _jwtDio.tokensChanges;
  }

  bool isConnectionSupportJwt() => _jwtDio.isConnectionSupportJwt();

  Future tryCatchDioErrorBodyWrapper(Future Function() v) async {
    try {
      await v.call();
    } on DioError catch (e) {
      // print(e.response!.statusCode!.toString() + " " + e.response!.data);
      throw ConnectionError.onDioError(e);
    }
  }

  void upgradeConnection(AccessibleByJWTTokens obj) {
    if (isConnectionSupportJwt()) {
      throw Exception("Connection already upgraded!");
    }
    _jwtDio.updateAccessibleByJWTTokens(obj);
  }

  void degradeConnection() {
    _jwtDio.updateAccessibleByJWTTokens(null);
  }

  Future<String> getAllOrders() async {
    Response? response;
    await tryCatchDioErrorBodyWrapper(() async {
      response = await _jwtDio.getUri(Uri.parse(API.ORDERS));
      return response;
    });
    return response.toString();
  }

  Future<void> addOrder(Order order) async {
    await tryCatchDioErrorBodyWrapper(() async {
      await _jwtDio.postUriObjectWithValidateByTokens(
          Uri.parse(API.ORDERS), order.getJsonableForm(JsonableOrderType.Add));
    });
  }

  Future<void> login(User user) async {
    await tryCatchDioErrorBodyWrapper(() async {
      var request = await _jwtDio.postUriObject(
          Uri.parse(API.LOGIN), user.getJsonableForm(JsonableUserType.Login));

      var tokens = request!.data as Map<String, dynamic>;
      print(tokens);
      user.setTokensByMap(tokens);
    });
  }

  Future<void> register(User user) async {
    await tryCatchDioErrorBodyWrapper(() async {
      await _jwtDio.postUriObject(Uri.parse(API.REGISTRATION),
          user.getJsonableForm(JsonableUserType.Register));
    });
  }
}
