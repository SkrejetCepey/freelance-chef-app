import 'package:bloc/bloc.dart';
import 'package:freelance_chef_app/bloc/network_service/network_bloc.dart';
import 'package:freelance_chef_app/bloc/repository/repository_bloc.dart';
import 'package:freelance_chef_app/models/interfaces/networkable.dart';
import 'package:freelance_chef_app/models/interfaces/repository_listenable.dart';
import 'package:freelance_chef_app/models/interfaces/serializable.dart';
import 'package:freelance_chef_app/models/user.dart';
import 'package:freelance_chef_app/services/user_service.dart';
import 'package:meta/meta.dart';

part 'user_service_event.dart';

part 'user_service_state.dart';

class UserServiceBloc extends Bloc<UserServiceEvent, UserServiceState>
    implements Networkable, RepositoryListenable, Serializable {
  late UserService _userService;

  UserServiceBloc(this.networkBloc, this.repositoryBloc)
      : super(UserServiceIdle()) {
    _userService = UserService(connection: networkBloc.getConnection());
    networkBloc.getConnection().tokensChangesJwtDio.stream.listen((event) {
      print("Tokens has been changed, user needs rebuild body!");
      _userService.changeTokens(event);
      repositoryBloc.repository.userRepository!.updateUserToken(_userService.getUserInfo()!);
    });

    repositoryBloc.stream.listen((state) async {
      if (state is RepositoryInitialized) {
        getSingleUserInDB().then((value) {
          print(value);
          if (value != null) {
            _userService.initUser(value);
            emit(UserServiceUserInitialised());
          }
        });
      }
    });

    on<UserServiceUpdateUser>((event, emit) {
      _userService.initUser(event.user);
      emit(UserServiceUserInitialised());
    });

    on<UserServiceDeleteUser>((event, emit) async {
      if ((await repositoryBloc.repository.userRepository!.getAllUsers()).isNotEmpty) {
        await repositoryBloc.repository.userRepository!.deleteUser(_userService.getUserInfo()!);
      }
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

  User? getUserInfoOrNull() {
    if (_userService.userExists()) {
      return _userService.getUserInfo()!;
    } else {
      return null;
    }
  }

  Future<User?> getSingleUserInDB() async {
    var allUsers = await repositoryBloc.repository.userRepository!.getAllUsers();
    if (allUsers.length > 1) {
      throw Exception("Not single user in db!");
    }
    if (allUsers.isEmpty) {
      return null;
    }

    // print(allUsers.toString());
    return allUsers[0];
  }

  @override
  NetworkBloc networkBloc;

  @override
  RepositoryBloc repositoryBloc;

}
