import 'package:bloc/bloc.dart';
import 'package:freelance_chef_app/bloc/error_service/error_service_bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/user_service/user_service_bloc.dart';
import 'package:freelance_chef_app/models/interfaces/error_throwable.dart';

import 'package:freelance_chef_app/models/interfaces/networkable.dart';
import 'package:freelance_chef_app/models/interfaces/user_changeable.dart';

import 'package:freelance_chef_app/models/user.dart';
import 'package:freelance_chef_app/network/connection_error.dart';
import 'package:meta/meta.dart';

part 'register_form_service_event.dart';

part 'register_form_service_state.dart';

class RegisterFormServiceBloc
    extends Bloc<RegisterFormServiceEvent, RegisterFormServiceState>
    implements Networkable, UserChangeable, ErrorThrowable {
  RegisterFormServiceBloc(this.networkBloc, this.userBloc, this.errorServiceBloc) : super(RegisterFormServiceIdle()) {

    on<RegisterFormSendData>((event, emit) async {
      emit(RegisterFormServiceWaitData());
      try {
        // auto login if registration success
        User _user = event.user;
        await networkBloc.getConnection().register(_user);
        await networkBloc.getConnection().login(_user);
        userBloc.add(UserServiceUpdateUser(_user));

        emit(RegisterFormServiceSuccess("Register success!"));
      } on ConnectionError catch (e) {
        errorServiceBloc.add(ErrorServiceEventThrowError("${e.errorCode}\n${e.errorText}"));
        emit(RegisterFormServiceIdle());
      }
    });
  }

  @override
  NetworkBloc networkBloc;

  @override
  UserServiceBloc userBloc;

  @override
  ErrorServiceBloc errorServiceBloc;
}
