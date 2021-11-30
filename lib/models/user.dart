import 'dart:convert';

import 'interfaces/jsonable.dart';
import 'mixins/accessible_by_jwt_tokens.dart';

enum JsonableUserType { Login, Register }

class User with AccessibleByJWTTokens {
  String? username;
  String? surname;
  String? name;
  String? phoneNumber;
  String? password;
  String? roleName;

  User();
  User.withParameters(this.username, this.surname, this.name, this.phoneNumber,
      this.password, this.roleName, String? accessToken, String? refreshToken) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  Jsonable getJsonableForm(JsonableUserType type) {
    switch (type) {
      case JsonableUserType.Login:
        return UserLogin(this);
      case JsonableUserType.Register:
        return UserRegister(this);
    }
  }

  User fullCopy() {
    return User.withParameters(username, surname, name, phoneNumber,
        password, roleName, accessToken, refreshToken);
  }

  @override
  void setTokensByMap(Map<String, dynamic> map) {
    accessToken = map["accessToken"];
    refreshToken = map["refreshToken"];
  }

  @override
  String toString() {
    return <String, String> {
      "username": username ?? "null",
      "surname": surname ?? "null",
      "name": name ?? "null",
      "phoneNumber": phoneNumber ?? "null",
      "password": password ?? "null",
      "roleName": roleName ?? "null",
      "accessToken": accessToken ?? "null",
      "refreshToken": refreshToken ?? "null",
    }.toString();
  }
}

class UserLogin implements Jsonable {
  User user;

  UserLogin(this.user);

  @override
  String getJson() {
    return json.encode(<String, dynamic>{
      "username": user.username,
      "phoneNumber": user.phoneNumber,
      "password": user.password
    });
  }
}

class UserRegister implements Jsonable {
  User user;

  UserRegister(this.user);

  @override
  String getJson() {
    return json.encode(<String, dynamic>{
      "username": user.username,
      "surname": user.surname,
      "name": user.name,
      "phoneNumber": user.phoneNumber,
      "password": user.password,
      "roleName": user.roleName
    });
  }
}
