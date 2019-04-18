import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final Repository _repository = Repository();

  // PublishSubject = StreamController
  final PublishSubject<List<int>> _topIds = PublishSubject();

  final BehaviorSubject<Map<int, Future<ItemModel>>> _itemsOutput =
      BehaviorSubject();

  final PublishSubject<int> _itemFetcher = PublishSubject();

  // Getters to stream
  Observable<List<int>> get topIds => _topIds.stream; // Observable = Stream
  Observable<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;

  // Getters to sink
  Function(int) get fetchItem => _itemFetcher.sink.add;

  StoriesBloc() {
    //pipe will get event from itemFetcher and transfer event to itemsOutput
    // Before transfering event to itemsOutput, itemFetcher event will be go through transformer
    _itemFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
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
    _itemsOutput.close();
    _itemFetcher.close();
  }
}
