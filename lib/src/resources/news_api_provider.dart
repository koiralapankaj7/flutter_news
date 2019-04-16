import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import '../models/item_model.dart';

final String _rootUrl = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider {
  Client client = Client();

  Future<List> fetchTopIds() async {
    final Response response = await client.get('$_rootUrl/topstories.json');

    // json.decode() return dynamic value. In this case we are sure that we will get list of id's
    final List ids = json.decode(response.body);
    return ids;
  }

  Future<ItemModel> fetchItem(int id) async {
    final Response response = await client.get('$_rootUrl/item/$id.json');
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}
