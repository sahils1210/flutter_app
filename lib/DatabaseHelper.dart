import 'dart:async';
import 'dart:io' as io;

import 'package:flutter_app_markemon/User.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/*
* class uses SQFLite plugin for Flutter to handle insertion and deletion of User credentials to the database. Note: Dart has inbuilt support for factory constructor, this means you can easily create a singleton without much ceremony.
* */

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      print("Db is not null");
      return _db;
    } else {
      print("Db is null");
      _db = await initDb();
      return _db;
    }
  }

  DatabaseHelper.internal();

  initDb() async {
    print("Entered initDB()");
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("CREATE TABLE `vendor_user_master` ("
        " `id` int(11) NOT NULL , "
        " `vendor_branch_master_id` int(11) NOT NULL, "
        " `vendor_user_name` varchar(555) NOT NULL, "
        " `vendor_user_email` varchar(100) NOT NULL,  "
        "`vendor_user_password` varchar(255) NOT NULL,  "
        "`city_code` varchar(10) NOT NULL, "
        " `user_type` varchar(20) NOT NULL ,"
        "  `medium` varchar(30) NOT NULL, "
        " `default_search_city_code` varchar(10) NOT NULL ,"
        "  `gender` varchar(6) NOT NULL,  "
        "`status` varchar(10),  "
        "`is_sync` tinyint(1) DEFAULT '0', "
        " `vendor_user_contact` varchar(20) DEFAULT NULL, "
        " `vendor_user_designation` varchar(255) DEFAULT NULL,"
        "  `vendor_user_profile_image` text,"
        "  `created_at` datetime NOT NULL,  "
        "`updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, "
        " PRIMARY KEY (`id`))");
    print("Created tables");

    await db.execute(
        'CREATE TABLE `state_master` (        `id` int(11) NOT NULL,    `country_code` varchar(555) DEFAULT NULL,    `state_name` text,    `state_code` varchar(555) DEFAULT NULL,    `mw_state_code` varchar(555) DEFAULT NULL,    `earlier_names` text,    `other_names` text,    `is_ut` tinyint(1) NOT NULL DEFAULT 0,    `created_on` datetime DEFAULT NULL,    `updated_on` datetime DEFAULT NULL,    `created_by` int(11) DEFAULT NULL,    `updated_by` int(11) DEFAULT NULL,    PRIMARY KEY (`id`) )');
    print("Created state tables");

    await db.execute('CREATE TABLE `district_master` '
        '(  `id` int(11) NOT NULL ,'
        '  `country_code` varchar(555) DEFAULT NULL, '
        ' `state_code` varchar(555) DEFAULT NULL, '
        ' `district_name` text, '
        ' `district_code` varchar(555) DEFAULT NULL,'
        '  `mw_district_code` varchar(555) DEFAULT NULL,  '
        '`earlier_names` text,  `other_names` text, '
        ' `created_on` datetime DEFAULT NULL,'
        '  `updated_on` datetime DEFAULT NULL,  '
        '`created_by` int(11) DEFAULT NULL,  '
        '`updated_by` int(11) DEFAULT NULL, '
        ' PRIMARY KEY (`id`)  )');
  }

  Future<User> saveUser(Map<String, dynamic> user) async {
    print('saveUser: ' + user.toString());
    var dbClient = await db;
    dbClient.transactionLock;

    int res = await dbClient.insert("vendor_user_master", user);
    print('saveUser res: ' + res.toString());
    if (res == 1) getUser();
    return null;
  }

  Future<int> saveStates(List<dynamic> states) async {
    print('save states: ' + states.toString());
    var dbClient = await db;

    int res = await dbClient.rawInsert("state_master", states);
    print('state_master res: ' + res.toString());
    //if res ==1 => success
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0 ? true : false;
  }

  void saveUserDetails(Map<String, dynamic> user) async {
    var dbClient = await db;
    var res = await dbClient.insert('vendor_user_master', user);
    print('res: ' + res.toString());
  }

  //To fetch user details
  /*Future<List<User>> getUser() async {
    print('Entered getUser ');
    var dbClient = await db;
    List<Map> res = await dbClient.query("vendor_user_master");

    print('Entered getUser res: ' + res.toString());
    return res.map((m) => User.fromMap(m)).toList();
  }*/

  Future<User> getUser() async {
    print('Entered getUser ');
    var dbClient = await db;
    var res = await dbClient.query("vendor_user_master");
    print('getUser: -> ${res}');

    if (res.length == 0) return null;
    return User.fromMap(res[0]);
  }

  void deleteAllTables() async {
    var dbClient = await db;
    await dbClient.delete("vendor_user_master");
  }
}

//https://github.com/tensor-programming/Flutter_Movie_Searcher_Final/blob/master/lib/screens/movieView.dart
