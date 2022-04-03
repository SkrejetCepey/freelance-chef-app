part of 'error_service_bloc.dart';

@immutable
abstract class ErrorServiceState {}

class ErrorServiceIdle extends ErrorServiceState {}
class ErrorProduce extends ErrorServiceState {}
