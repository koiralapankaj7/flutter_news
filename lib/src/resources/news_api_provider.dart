import 'dart:convert';
import 'package:http/http.dart' show Client, Response;
import '../models/item_model.dart';

final String _rootUrl = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider {
  Client client = Client();

  Future<List<int>> fetchTopIds() async {
    final Response response = await client.get('$_rootUrl/topstories.json');

    // json.decode() return dynamic value. In this case we are sure that we will get list of id's
    final ids = json.decode(response.body);

    // While fetching json.decode(response.body); this dart does not have any idea about its data type.
    // That is why we need to type caste. As we are sure that data type will be list of integer.
    // If we miss casting this will cause error in testing file.
    return ids.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final Response response = await client.get('$_rootUrl/item/$id.json');
    final Map<String, dynamic> parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }
}
