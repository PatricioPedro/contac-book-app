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

  Database? _db;

  Future<Database?> get db async {
    // ignore: unnecessary_null_comparison
    if (_db != null) {
      return _db;
    }

    _db = await initDb();

    return _db;
  }

  initDb() async {
    // Will store the local path for our database
    final databasesPath = await getDatabasesPath();

    // Will join the local storage path with our database name
    final path = join(databasesPath, "contactsBD.db");

    // Will open our database relatively our config, and will create our table at first
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      db.execute('''CREATE TABLE $tableName(
              $idColumn INTEGER PRIMARY KEY,
              $nameColumn TEXT, 
              $phoneColumn TEXT,
              $imgColumn TEXT,
              $emailColumn TEXT);''');
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database? dbContact = await db;
    contact.id = await dbContact!.insert(tableName, contact.toMap());
    return contact;
  }

  Future<List> getAllContacts() async {
    Database? database = await db;

    List<Map<String, Object?>> contacts =
        await database!.rawQuery("SELECT * FROM $tableName");

    List<Contact> listContacts = [];

    for (var contact in contacts) {
      listContacts.add(Contact.fromMap(contact));
    }

    return listContacts;
  }

  // Will return contact from past id
  getContact(int id) async {
    Database? dbContact = await db;

    List<Map<String, dynamic>> maps = await dbContact!.query(tableName,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (maps.first.isNotEmpty) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int? id) async {
    /*
    Will delete a contact 
    The parameter id is required
  */
    Database? dbContact = await db;
    return dbContact!
        .delete(tableName, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    /*
      Will update a contact
     */
    Database? dbContact = await db;

    return await dbContact!.update(tableName, contact.toMap(),
        where: "$idColumn = ?", whereArgs: [contact.id]);
  }
}

/*
  It's responsible for save a new contact in the database contact
 */

/*
  The class Contact is a model for our app
*/

class Contact {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? img;

  Contact();

  Contact.fromMap(Map<String, dynamic> map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    img = map[imgColumn];
    phone = map[phoneColumn];
  }

  Map<String, dynamic> toMap() {
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
