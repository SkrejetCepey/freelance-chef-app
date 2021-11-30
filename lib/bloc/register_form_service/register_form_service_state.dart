part of 'register_form_service_bloc.dart';

@immutable
abstract class RegisterFormServiceState with ErrorThrowable {}

class RegisterFormServiceInitial extends RegisterFormServiceState {}

class RegisterFormServiceIdle extends RegisterFormServiceState {}

class RegisterFormServiceSuccess extends RegisterFormServiceState {
  String successMessage;

  RegisterFormServiceSuccess(this.successMessage);
}

class RegisterFormServiceWaitData extends RegisterFormServiceState {}