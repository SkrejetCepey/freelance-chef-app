import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freelance_chef_app/bloc/error_service/error_service_bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/repository/repository_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/interfaces/error_throwable.dart';
import 'package:freelance_chef_app/models/interfaces/serializable.dart';
import 'package:freelance_chef_app/models/interfaces/user_changeable.dart';
import 'package:freelance_chef_app/models/interfaces/networkable.dart';
import 'package:freelance_chef_app/models/user.dart';
import 'package:freelance_chef_app/network/connection_error.dart';
import 'package:meta/meta.dart';

part 'login_form_service_event.dart';

part 'login_form_service_state.dart';

class LoginFormServiceBloc
    extends Bloc<LoginFormServiceEvent, LoginFormServiceState>
    implements Networkable, UserChangeable, Serializable, ErrorThrowable {
  @override
  ErrorServiceBloc errorServiceBloc;

  @override
  NetworkBloc networkBloc;

  @override
  UserServiceBloc userBloc;

  LoginFormServiceBloc(this.networkBloc, this.userBloc, this.repositoryBloc, this.errorServiceBloc)
      : super(LoginFormServiceIdle()) {
    on<LoginFormSendData>((event, emit) async {
      emit(LoginFormServiceWaitData());
      try {
        User _user = event.user;
        await networkBloc.getConnection().login(_user);

        if (_user.refreshToken == null || _user.accessToken == null) {
          throw Exception(
              "BlocException: Connection success, but tokens were not received!");
        }

        if (event.stateStayInAccountSwitch) {
          print("Add users by login_form_service!");
          repositoryBloc.add(RepositoryEventAddUserIfUsersEmpty(_user));
        }

        userBloc.add(UserServiceUpdateUser(_user));
        emit(LoginFormServiceSuccess("Login success!"));
      } on ConnectionError catch (e) {
        errorServiceBloc.add(ErrorServiceEventThrowError("${e.errorCode}\n${e.errorText}"));
        emit(LoginFormServiceIdle());
      }
    });
  }

  @override
  RepositoryBloc repositoryBloc;
}
