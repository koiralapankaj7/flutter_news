import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  final Repository _repository = Repository();
  final PublishSubject<int> _commentsFetcher = PublishSubject();
  final BehaviorSubject<Map<int, Future<ItemModel>>> _commentsOutput =
      BehaviorSubject();

  // Streams getters
  // Observable<int> get commentIds => _commentsFetcher.stream;
  Observable<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  // Sink getters
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  _commentsTransformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, int index) {
        //Fetch ItemModel of id from repository and add into cache map
        // Fetch Future of item model from repository and assign to cache map
        cache[id] = _repository.fetchItem(id);

        /*
         *  cache[id] => Reference back to the cache map and we will get the future we just map there
         *  And we chain on .then statement
         *  Inner functiion of .then will be invoked whenever that future finally get its ItemModel from the repository.
         */
        cache[id].then((ItemModel item) {
          // Loop through kids in ItemModel then add/sink each kid id to fetchItemWithComments function
          // This kid id will be processed by _commentsFetcher Subject/Controller by transfering into
          // _commentsTransofrmer
          // This is recursive data fetching concept
          item.kids.forEach((kidId) => fetchItemWithComments(kidId));
        });

        return cache;
      },
      // Cache map
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _commentsFetcher.close();
    _commentsOutput.close();
  }
}
