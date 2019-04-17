import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/item_model.dart';

class Repository {
  //
  NewsDbProvider dbProvider = NewsDbProvider();
  NewsApiProvider apiProvider = NewsApiProvider();

  // 1. Fetch top ids will be possible only through api provider.
  Future<List<int>> fetchTopIds() => apiProvider.fetchTopIds();

  // 2. Fetch item from local db/api
  Future<ItemModel> fetchItem(int id) async {
    //
    //Fetch item from local db
    ItemModel item = await dbProvider.fetchItem(id);

    // If item is not null i.e, item found in local db. Then instantly return item.
    if (item != null) {
      return item;
    }

    // Couldnt find item in local db so fetch from api
    item = await apiProvider.fetchItem(id);

    // After fetching item from api store item into local db for future use
    dbProvider.addItem(item);

    // After add item to local db return item
    return item;
  }
  //
}
