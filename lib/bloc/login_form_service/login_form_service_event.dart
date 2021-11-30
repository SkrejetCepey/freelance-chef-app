part of 'login_form_service_bloc.dart';

@immutable
abstract class LoginFormServiceEvent {}

class LoginFormSendData extends LoginFormServiceEvent {
  final User user;

  LoginFormSendData(this.user);
}
