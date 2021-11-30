import 'dart:async';

import 'package:dio/dio.dart';
import 'package:freelance_chef_app/models/mixins/accessible_by_jwt_tokens.dart';
import 'package:freelance_chef_app/models/order.dart';
import 'package:freelance_chef_app/models/user.dart';
import 'package:freelance_chef_app/network/jwt_dio.dart';

import 'api.dart';

class Connection {
  late JWTDio _jwtDio;
  late AccessibleByJWTTokens? _c;

  Connection(AccessibleByJWTTokens? c) {
    _c = c;
    _jwtDio = JWTDio(_c);
  }

  bool isConnectionSupportJwt() => _jwtDio.isConnectionSupportJwt();

  void upgradeConnection(AccessibleByJWTTokens obj) {
    // TODO think about it
    if (_c != null) {
      throw Exception("Connection already upgraded!");
    }
    _c = obj;
    _jwtDio = JWTDio(_c);
  }

  void degradeConnection() {
    _c = null;
    _jwtDio = JWTDio(_c);
  }

  Future<String> getAllOrders() async {
    try {
      var request = await _jwtDio.getUri(Uri.parse(API.ORDERS));
      return request.toString();
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(Order order) async {
    try {
      print(order.getJsonableForm(JsonableOrderType.Add).getJson());
      var request = await _jwtDio.postUriObjectWithValidateByTokens(
          Uri.parse(API.ORDERS),
          order.getJsonableForm(JsonableOrderType.Add),
          _c!);
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<void> login(User user) async {
    try {
      var request = await _jwtDio.postUriObject(
          Uri.parse(API.LOGIN), user.getJsonableForm(JsonableUserType.Login));

      var tokens = request!.data as Map<String, dynamic>;
      user.setTokensByMap(tokens);
    } on DioError catch (e) {
      throw e;
    }
  }

  Future<void> register(User user) async {
    try {
      print(user.getJsonableForm(JsonableUserType.Register).getJson());
      var request = await _jwtDio.postUriObject(Uri.parse(API.REGISTRATION),
          user.getJsonableForm(JsonableUserType.Register));

      // return request.toString();
    } on DioError catch (e) {
      throw e;
    }
  }
}

// class StaticConnection {
//   static final JWTDio _jwtDio = JWTDio(null);
//   // late AccessibleByJWTTokens? _c;
//
//   // B(AccessibleByJWTTokens? c) {
//   //   // _c = c;
//   //   _jwtDio = JWTDio(_c);
//   // }
//
//   static Future<String> getAllOrders() async {
//     try {
//       var request = await _jwtDio.getUri(Uri.parse(API.GET_ALL_ORDERS));
//       return request.toString();
//     } on DioError catch (e) {
//       throw e;
//     }
//   }
//
// }
