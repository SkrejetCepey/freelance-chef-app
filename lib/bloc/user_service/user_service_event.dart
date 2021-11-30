part of 'user_service_bloc.dart';

@immutable
abstract class UserServiceEvent {}

class UserServiceUpdateUser extends UserServiceEvent {
  final User user;

  UserServiceUpdateUser(this.user);
}

class UserServiceDeleteUser extends UserServiceEvent {}
