import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freelance_chef_app/models/user.dart';
import 'package:freelance_chef_app/repository/repository.dart';
import 'package:meta/meta.dart';

part 'repository_event.dart';
part 'repository_state.dart';

class RepositoryBloc extends Bloc<RepositoryEvent, RepositoryState> {
  late Repository repository;

  RepositoryBloc() : super(RepositoryInit()) {
    repository = Repository();
    repository.init().whenComplete(() {
      emit(RepositoryInitialized());
      emit(RepositoryIdle());
    });

    on<RepositoryEventAddUserIfUsersEmpty>((event, emit) async {
      await repository.userRepository!.addUserIfUsersEmpty(event.user);
      emit(RepositoryIdle());
    });
  }
}
