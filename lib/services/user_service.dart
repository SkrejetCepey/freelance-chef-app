import 'package:freelance_chef_app/models/user.dart';
import 'package:freelance_chef_app/network/connection.dart';

class UserService {
  late Connection _connection;
  User? _user;

  UserService({required Connection connection, User? user}) {
    _connection = connection;
    _user = user;
  }

  void initUser(User user) {
    if (userExists()) {
      throw Exception("UserServiceError: User already init!");
    }
    _user = user;
    _connection.upgradeConnection(_user!);
  }

  void deleteUser() {
    if (userExists()) {
      _user = null;
      _connection.degradeConnection();
    } else {
      throw Exception("UserServiceError: User already init!");
    }
  }

  bool userExists() => _user != null;

  User? getUserInfo() => (userExists()) ? _user!.fullCopy() : null;

}