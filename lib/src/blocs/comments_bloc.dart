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
        cache[id] = _repository.fetchItem(id);
        // As soon as this (cache[id]) future resoulves as ItemModel that we are trying to fetch.
        // Function inside then((){}) will be invoked.
        cache[id].then((ItemModel item) {
          // Loop through kids in ItemModel then add/sink each kid id to fetchItemWithComments function
          // This kid id will be processed by _commentsFetcher Subject/Controller by transfering into
          // _commentsTransofrmer
          item.kids.forEach((kidId) => fetchItemWithComments(kidId));
        });
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
