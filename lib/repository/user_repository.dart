import 'package:freelance_chef_app/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {

  Database database;

  UserRepository(this.database);

  Future<void> addUserIfUsersEmpty(User user) async {

    var count = Sqflite.firstIntValue(await database.rawQuery('SELECT COUNT(*) FROM users'));
    if (count! < 0) {
      print("Users in database isn't empty, needs to check!");
      return;
    }

    await database.transaction((txn) async {
      int id = await txn.rawInsert(
          'INSERT INTO users(username, phoneNumber, password, access_token, refresh_token) VALUES(?, ?, ?, ?, ?)',
          [user.username, user.phoneNumber, user.password, user.accessToken, user.refreshToken]);
      print('inserted: $id');
    });
  }

  Future<List<User>> getAllUsers() async {
    List<Map> list = await database.rawQuery('SELECT * FROM Users');
    List<User> usersList = list.map((e) => _dbToModelUser(e)).toList();
    return usersList;
  }

  Future<void> updateUserToken(User user) async {
    await database.rawUpdate('UPDATE Users WHERE username = ? AND password = ?', [user.username, user.password]);
  }

  Future<void> deleteUser(User user) async {
    await database.rawDelete('DELETE FROM Users WHERE username = ? AND password = ?', [user.username, user.password]);
  }

  User _dbToModelUser(Map dbModel) {
    return User.withParameters(dbModel["username"], dbModel["surname"], dbModel["name"], dbModel["phoneNumber"], dbModel["phoneNumber"], dbModel["roleName"],
        dbModel["access_token"], dbModel["refresh_token"]);
  }

}