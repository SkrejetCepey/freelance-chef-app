import 'package:bloc/bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/models/interfaces/networkable.dart';
import 'package:freelance_chef_app/models/user.dart';
import 'package:freelance_chef_app/services/user_service.dart';
import 'package:meta/meta.dart';

part 'user_service_event.dart';

part 'user_service_state.dart';

class UserServiceBloc extends Bloc<UserServiceEvent, UserServiceState>
    implements Networkable {

  late UserService _userService;

  UserServiceBloc(this.networkBloc) : super(UserServiceIdle()) {
    _userService = UserService(connection: networkBloc.getConnection());

    on<UserServiceUpdateUser>((event, emit) {
      _userService.initUser(event.user);
      emit(UserServiceUserInitialised());
    });

    on<UserServiceDeleteUser>((event, emit) {
      _userService.deleteUser();
      emit(UserServiceIdle());
    });
  }

  User getUserInfo() {
    if (_userService.userExists()) {
      return _userService.getUserInfo()!;
    } else {
      throw Exception("UserNotInitialised!");
    }

  }

  @override
  NetworkBloc networkBloc;
}
