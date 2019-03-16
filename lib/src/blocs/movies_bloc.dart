import 'package:hello_bloc/src/blocs/Base/bloc_provider.dart';
import 'package:hello_bloc/src/models/favorite_model.dart';
import 'package:hello_bloc/src/models/item_model.dart';
import 'package:hello_bloc/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc extends BaseBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();
  final _favortite = PublishSubject<FavoriteModel>();
  final _isFavoriteSubject = BehaviorSubject<bool>();

  List<FavoriteModel> _favoritList = List<FavoriteModel>();

  Observable<ItemModel> get allMovies => _moviesFetcher.stream;
  Function(FavoriteModel) get addToFavorite => _favortite.sink.add;

  void fetchAllMovies() async {
    ItemModel itemModels = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModels);
    _favortite.listen(addFavorite);
  }

  void dispose() {
    _moviesFetcher.close();
    _favortite.close();
    _isFavoriteSubject.close();
  }

  void addFavorite(FavoriteModel movie) {
    print(movie);
    for (var item in _favoritList) {
      print(item);
    }
    print(_favoritList.any((x) => x.id == movie.id));

    if (_favoritList.any((x) => x.id == movie.id))
      _favoritList.remove(movie);
    else
      _favoritList.add(movie);

    for (var item in _favoritList) {
      print(item);
    }

    _notify(_favoritList.any((x) => x.id == movie.id));
  }

  void _notify(bool isfavorite) {
    _isFavoriteSubject.sink.add(isfavorite);
  }
}
