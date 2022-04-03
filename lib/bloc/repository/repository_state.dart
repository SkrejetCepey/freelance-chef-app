part of 'repository_bloc.dart';

@immutable
abstract class RepositoryState {}

class RepositoryInit extends RepositoryState {}
class RepositoryInitialized extends RepositoryState {}
class RepositoryIdle extends RepositoryState {}

class RepositoryAddUserIfUsersEmpty extends RepositoryState {}
