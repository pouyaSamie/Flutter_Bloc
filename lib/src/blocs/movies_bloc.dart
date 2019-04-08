import 'package:hello_bloc/src/blocs/Base/bloc_provider.dart';
import 'package:hello_bloc/src/models/favorite_model.dart';
import 'package:hello_bloc/src/models/item_model.dart';
import 'package:hello_bloc/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc extends BaseBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();
  final _updatefavortite = PublishSubject<FavoriteMovie>();
  final _isfavorite = BehaviorSubject<int>();

  //List<FavoriteMovie> _favoritList = List<FavoriteMovie>();

  Observable<ItemModel> get allMovies => _moviesFetcher.stream;
  Function(FavoriteMovie) get addToFavorite => _updatefavortite.sink.add;

  Function(int) get isFavorite => _isfavorite.sink.add;
  Observable<bool> get getFavoriteStatus =>
      _isfavorite.asyncMap((data) => _repository.isFavorite(data));

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

  Future addFavorite(FavoriteMovie movie) async {
    var val = await _repository.isFavorite(movie.id);
    if (!val)
      _repository.addToFavorite(movie);
    else
      _repository.deleteFavorite(movie);

    _notify(movie);
  }

  _notify(FavoriteMovie movie) {
    isFavorite(movie.id);
  }
}
