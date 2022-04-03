part of 'repository_bloc.dart';

@immutable
abstract class RepositoryEvent {}

class RepositoryEventAddUserIfUsersEmpty extends RepositoryEvent {
  User user;

  RepositoryEventAddUserIfUsersEmpty(this.user);
}
