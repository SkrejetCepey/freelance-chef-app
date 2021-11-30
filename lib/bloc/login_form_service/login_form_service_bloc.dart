import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/interfaces/user_changeable.dart';
import 'package:freelance_chef_app/models/mixins/error_throwable.dart';
import 'package:freelance_chef_app/models/interfaces/networkable.dart';
import 'package:freelance_chef_app/models/user.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

part 'login_form_service_event.dart';

part 'login_form_service_state.dart';

class LoginFormServiceBloc
    extends Bloc<LoginFormServiceEvent, LoginFormServiceState>
    implements Networkable, UserChangeable {
  LoginFormServiceBloc(this.networkBloc, this.userBloc) : super(LoginFormServiceIdle()) {
    on<LoginFormSendData>((event, emit) async {
      emit(LoginFormServiceWaitData());
      try {
        User _user = event.user;
        await networkBloc.getConnection().login(_user);
        userBloc.add(UserServiceUpdateUser(_user));
        emit(LoginFormServiceSuccess("Login success!"));
      } on DioError catch (e) {
        emit(LoginFormServiceIdle()..setErrorMessage("${e.response!.statusCode}\n${e.response!.data}"));
      }
    });
  }

  @override
  NetworkBloc networkBloc;

  @override
  UserServiceBloc userBloc;
}
