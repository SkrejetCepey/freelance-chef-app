mixin AccessibleByJWTTokens {
  String? accessToken;
  String? refreshToken;

  void setTokensByMap(Map<String, dynamic> map) {
    accessToken = map["accessToken"];
    refreshToken = map["refreshToken"];
    print("map access token: ${map["accessToken"]}");
    print("accesstoken: ${accessToken}");
  }
}