part of 'login_form_service_bloc.dart';

@immutable
abstract class LoginFormServiceState with ErrorThrowable {}

class LoginFormServiceInitial extends LoginFormServiceState {}


class LoginFormServiceSuccess extends LoginFormServiceState {
  String successMessage;

  LoginFormServiceSuccess(this.successMessage);
}

class LoginFormServiceIdle extends LoginFormServiceState {}

class LoginFormServiceWaitData extends LoginFormServiceState {}
