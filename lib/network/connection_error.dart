import 'package:dio/dio.dart';

class ConnectionError implements Exception {
  //TODO add support to get dictionary of all exception on client side (take from repo(save memory tactic))
  late String errorCode;
  late String errorText;

  factory ConnectionError.onDioError(DioError e) {
    return (e.response == null)
        ? ConnectionError.withCode(
            "ClientSideError", "No Internet/Service not available")
        : ConnectionError._withDioResponse(e.response!);
  }

  ConnectionError.withCode(this.errorCode, this.errorText);

  ConnectionError._withDioResponse(Response r) {
    errorCode = r.statusCode.toString();
    errorText = r.data.toString();
  }
}
