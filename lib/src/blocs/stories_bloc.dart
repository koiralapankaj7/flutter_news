import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final Repository _repository = Repository();

  // PublishSubject = StreamController
  final PublishSubject _topIds = PublishSubject<List<int>>();

  final BehaviorSubject _items = BehaviorSubject<int>();

  Observable<Map<int, Future<ItemModel>>> items;

  // Getters to stream
  Observable<List<int>> get getTopIds => _topIds.stream; // Observable = Stream

  // Getters to sink
  Function(int) get fetchItem => _items.sink.add;

  StoriesBloc() {
    // To apply transformer exactly one time we have done this way.
    // If we apply transformer multiple time it will be ended up by creating seperate cache.
    items = _items.stream.transform(_itemsTransformer());
  }

  /*
   * We did not make getter for sink here because widget is not going to call/chage data here.
   * Repository is responsible for callig/changing data that is why to hide sink function 
   * from widgets we made function instead of getter for sink. 
   */
  void fetchTopIds() async {
    // Getting ids from repository
    final List<int> ids = await _repository.fetchTopIds();
    // Adding ids to sink
    _topIds.sink.add(ids);
  }

  // this will take id as a parameter then fetch item for that id. After that it will add both
  // id and item to cache and return that cache for further use.
  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, int index) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{}, // Cache
    );
  }

  void dispose() {
    _topIds.close();
    _items.close();
  }
}
