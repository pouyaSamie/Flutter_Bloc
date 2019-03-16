import 'package:hello_bloc/src/blocs/Base/bloc_provider.dart';
import 'package:hello_bloc/src/models/favorite_model.dart';
import 'package:hello_bloc/src/models/item_model.dart';
import 'package:hello_bloc/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc extends BaseBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();
  final _updatefavortite = PublishSubject<FavoriteModel>();
  final _isfavorite = BehaviorSubject<int>();

  List<FavoriteModel> _favoritList = List<FavoriteModel>();

  Observable<ItemModel> get allMovies => _moviesFetcher.stream;
  Function(FavoriteModel) get addToFavorite => _updatefavortite.sink.add;

  Function(int) get isFavorite => _isfavorite.sink.add;
  Observable<bool> get getFavoriteStatus =>
      _isfavorite.map((data) => _favoritList.any((x) => x.id == data));

  MoviesBloc() {
    _updatefavortite.listen(addFavorite);
  }

  void fetchAllMovies() async {
    ItemModel itemModels = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModels);
  }

  void dispose() {
    _moviesFetcher.close();
    _updatefavortite.close();
    _isfavorite.close();
  }

  void addFavorite(FavoriteModel movie) {
    if (_favoritList.any((x) => x.id == movie.id)) {
      _favoritList.removeWhere((m) => m.id == movie.id);
    } else
      _favoritList.add(movie);

    _notify(movie);
  }

  _notify(FavoriteModel movie) {
    isFavorite(movie.id);
  }
}
