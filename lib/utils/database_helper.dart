import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }


  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Member(id INTEGER PRIMARY KEY, name TEXT, surname TEXT, mail TEXT, mobile TEXT, phone TEXT)");
    print("Member created tables");
  }

  /*class User {
  String _username;
  String _password;
  User(this._usn, this._password);

  User.map(dynamic obj) {
  this._username = obj["username"];
  this._password = obj["password"];
  }

  String get username => _username;
  String get password => _password;

  Map<String, dynamic> toMap() {
  var map = new Map<String, dynamic>();
  map["username"] = _username;
  map["password"] = _password;

  return map;
  }
  }*/

  /*Future<int> saveUser(Member member) async {
    var dbClient = await db;
    int res = await dbClient.insert("Member", member.toMap());
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("Member");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("Member");
    return res.length > 0? true: false;
  }*/

}