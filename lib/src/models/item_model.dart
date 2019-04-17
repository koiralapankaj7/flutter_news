import 'dart:convert';

class ItemModel {
  final int id;
  final bool deleted;
  final String type;
  final String by;
  final int time;
  final String text;
  final bool dead;
  final int parent;
  final List<dynamic> kids;
  final String url;
  final int score;
  final String title;
  final int descendants;

  // This named constructor will be used by api provider class to map and store data fetched from the API.
  ItemModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        deleted = parsedJson['deleted'],
        type = parsedJson['type'],
        by = parsedJson['by'],
        time = parsedJson['time'],
        text = parsedJson['text'],
        dead = parsedJson['dead'],
        parent = parsedJson['parent'],
        kids = parsedJson['kids'],
        url = parsedJson['url'],
        score = parsedJson['score'],
        title = parsedJson['title'],
        descendants = parsedJson['descendants'];

  /*
   * This named constructor will be used by db provider class to map and store data fetched from the local db.
   * We are not going to receive boolean value from local database as there is no support for such data type.
   * Insted of boolean we will get integer value in form of 1(true) and 0(false).
   * But in our model class we have declared data type as boolean so to handle this issue we are creating 
   * different constructor.
   */
  ItemModel.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        // Value of deleted is one => true. otherwise false
        deleted = parsedJson['deleted'] == 1,
        type = parsedJson['type'],
        by = parsedJson['by'],
        time = parsedJson['time'],
        text = parsedJson['text'],
        dead = parsedJson['dead'] == 1,
        parent = parsedJson['parent'],
        // In databse we have stored list as blob so we are converting blob back to list.
        kids = jsonDecode(parsedJson['kids']),
        url = parsedJson['url'],
        score = parsedJson['score'],
        title = parsedJson['title'],
        descendants = parsedJson['descendants'];

  // this method will convert ItemModel class to map so that we can insert item in local database easily.
  // As database does not support boolean and list we are converting boolean to integer and list to blob.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "deleted": deleted ? 1 : 0,
      "type": type,
      "by": by,
      "time": time,
      "text": text,
      "dead": dead ? 1 : 0,
      "parent": parent,
      "kids": jsonEncode(kids),
      "url": url,
      "score": score,
      "title": title,
      "descendants": descendants
    };
  }
}

//command + D => select same
//command/option + right arrow => next to first word
//command/option + shift + right arrow => select remaining from the cursor
