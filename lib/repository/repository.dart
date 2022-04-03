import 'package:freelance_chef_app/repository/user_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Repository {

  late Database? database;
  late UserRepository? userRepository;

  Repository();

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'freelance_chef_app.db');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {

          await db.execute(
              "CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT, surname TEXT, name TEXT, phoneNumber TEXT, password TEXT, roleName TEXT, NAVI_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP, access_token TEXT, refresh_token TEXT)");
        });

    userRepository = UserRepository(database!);

  }


}