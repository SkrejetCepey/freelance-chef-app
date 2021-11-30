part of 'user_service_bloc.dart';

@immutable
abstract class UserServiceState {}

class UserServiceIdle extends UserServiceState {}
class UserServiceUserInitialised extends UserServiceState {}
