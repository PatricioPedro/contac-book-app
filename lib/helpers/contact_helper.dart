/*
  This Class Contains all attributes and methods to init database Configuration
 */
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/*
   It's dynamic name from our database 
*/
const String tableName = "contacts";
const String idColumn = "idColumn";
const String nameColumn = "nameColumn";
const String phoneColumn = "phoneColumn";
const String imgColumn = "imgColumn";
const String emailColumn = "emailColumn";

// ==============================================
class ContactHelper {
  // It's an use of Singleton pattern

  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  // This varialble will contain DataBase Config

  late Database _db;

  Future<Database> get db async {
    // ignore: unnecessary_null_comparison
    if (db != null) {
      return _db;
    }

    _db = await initDb();

    return _db;
  }

  initDb() async {
    // Will store the local path for our database
    final databasesPath = await getDatabasesPath();

    // Will join the local storage path with our database name
    final path = join(databasesPath, "contact.db");

    // Will open our database relatively our config, and will create our table at first
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      db.execute('''CREATE TABLE $tableName(
              $idColumn INTEGER,
              $nameColumn TEXT, 
              $phoneColumn TEXT,
              $imgColumn TEXT,
              $emailColumn TEXT);''');
    });
  }
}

/*
  The class Contact is a model for our app
*/

class Contact {
  late int id;
  late String name;
  late String email;
  late String phone;
  late String img;

  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    img = map[imgColumn];
    phone = map[phoneColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      phoneColumn: phone,
      emailColumn: email,
      imgColumn: img
    };

    // ignore: unnecessary_null_comparison
    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }
}
