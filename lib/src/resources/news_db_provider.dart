import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';

class NewsDbProvider {
  Database db; // Sqflite lib
  final String _dbName = "items.db";
  final int _dbVersion = 1;
  final String _table = "Items"; // Table name

  /*
   * Inside our constructor we cannot have asynchronous logic.
   * That is why we are making init() function to do initial setup. 
   */

  void init() async {
    /*
     * getApplicationDocumentsDirectory() => Path Provider Lib 
     * Directory => IO lib
     * join => Path lib
     * openDatabase function will either open database at given path or if there is no database at 
     * given path then its going to create new one for us. If database exist open it otherwise create it.
     * onCreate will only called very first time user start the application
     */
    // Getting documents directory from mobile device
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Path for database
    final String path = join(documentsDirectory.path, _dbName);

    db = await openDatabase(path, version: _dbVersion,
        onCreate: (Database newDb, int version) {
      // For multi line string we have to use tripple quotes
      // WE DO NOT HAVE ANY SPECIFIC DATA TYPE TO STORE LIST ITEM IN DATABASE.
      // SO WE ARE USING BLOB TO STORE LIST AS BLOB CAN HOLD ANY TYPE OF BIG DATA.
      // THERE IS NO BOOLEAN DATA TYPE IN SQFLITE DATABASE. SO WE ARE USING INTEGER INSTED OF BOOLEAN.
      // 1 MEANS TRUE AND 0 MEANS FALSE. WILL HANDLE THIS LOGIC LATER.
      newDb.execute("""
            CREATE TABLE $_table
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER
            )
          """);
    });
  }

  Future<ItemModel> fetchItem(int id) async {
    //
    // Column is set as null because we want to fetch entire items. If we need any specific item then we can
    // use columns : ["item name"] to get single item.
    final List<Map<String, dynamic>> maps = await db.query(
      //
      // table name
      _table,

      // Fetch all columns i.e items
      columns: null,

      // ? means something we are gonna pass as argument to the query
      // Question mark will be replaced by first element of the whereArgs list.
      where: "id = ?",

      // Passing id as a argument to the query.
      // This mechanisum is used to protect sql injection.
      whereArgs: [id],
      //
    );

    // We know we will get either 1 or 0 map from the db but db.query() will return us list of maps.
    // That is why we are using maps.first to get first map element from the list.
    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }

    return null;
  }

  // Add item in local database
  // We are not waiting for completion of inseration process which is the reason we didnot specify async in this method
  Future<int> addItem(ItemModel item) {
    return db.insert(_table, item.toMap());
  }
}
