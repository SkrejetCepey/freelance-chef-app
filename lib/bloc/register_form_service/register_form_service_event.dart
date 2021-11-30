part of 'register_form_service_bloc.dart';

@immutable
abstract class RegisterFormServiceEvent {}

class RegisterFormSendData extends RegisterFormServiceEvent {
  final User user;

  RegisterFormSendData(this.user);
}