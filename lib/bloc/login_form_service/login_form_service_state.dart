part of 'login_form_service_bloc.dart';

@immutable
abstract class LoginFormServiceState {}


class LoginFormServiceIdle extends LoginFormServiceState {}

class LoginFormServiceSuccess extends LoginFormServiceIdle {
  String successMessage;

  LoginFormServiceSuccess(this.successMessage);
}

class LoginFormServiceWaitData extends LoginFormServiceState {}
