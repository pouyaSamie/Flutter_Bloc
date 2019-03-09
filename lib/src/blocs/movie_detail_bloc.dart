import 'package:hello_bloc/src/models/trailer_model.dart';
import 'package:hello_bloc/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc {
  final _repository = Repository();
  final _movieId = PublishSubject<int>();
  final _trailers = BehaviorSubject<Future<TrailerModel>>();
  final _toggleFavorite = BehaviorSubject<int>();
  final _isFavoriteSubject = BehaviorSubject<bool>();
  final _favoritList = List<int>();

  Function(int) get fetchTrailersById => _movieId.sink.add;
  Observable<Future<TrailerModel>> get movieTrailers => _trailers.stream;

  Function(int) get toggleFavorite => _toggleFavorite.sink.add;
  Observable<bool> get isFavorite => _isFavoriteSubject.stream;
  MovieDetailBloc() {
    _movieId.stream.transform(_itemTransformer()).pipe(_trailers);
    _movieId.listen(_notify);
    _toggleFavorite.stream.listen(addFavorite);
  }

  dispose() async {
    _movieId.close();

    await _trailers.drain();
    _trailers.close();
    _toggleFavorite.close();
    _isFavoriteSubject.close();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Future<TrailerModel> trailer, int id, int index) {
        print(index);
        trailer = _repository.fetchTrailers(id);
        return trailer;
      },
    );
  }

  void addFavorite(int movieId) {
    if (_favoritList.contains(movieId))
      _favoritList.remove(movieId);
    else
      _favoritList.add(movieId);

    print(_favoritList);
    _notify(movieId);
  }

  void _notify(int movieId) {
    _isFavoriteSubject.sink.add(_favoritList.contains(movieId));
  }
}
