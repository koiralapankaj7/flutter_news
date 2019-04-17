import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';

class NewsDbProvider {
  Database db; // Sqflite lib

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
    final String path = join(documentsDirectory.path, 'items.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      // For multi line string we have to use tripple quotes
      // WE DO NOT HAVE ANY SPECIFIC DATA TYPE TO STORE LIST ITEM IN DATABASE.
      // SO WE ARE USING BLOB TO STORE LIST AS BLOB CAN HOLD ANY TYPE OF BIG DATA.
      // THERE IS NO BOOLEAN DATA TYPE IN SQFLITE DATABASE. SO WE ARE USING INTEGER INSTED OF BOOLEAN.
      // 1 MEANS TRUE AND 0 MEANS FALSE. WILL HANDLE THIS LOGIC LATER.
      newDb.execute("""
            CREATE TABLE Items
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
}
