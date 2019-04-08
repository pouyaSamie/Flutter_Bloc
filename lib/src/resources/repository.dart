import 'package:hello_bloc/src/models/favorite_model.dart';
import 'package:hello_bloc/src/models/item_model.dart';
import 'package:hello_bloc/src/models/trailer_model.dart';
import 'package:hello_bloc/src/resources/movie_api_provider.dart';
import 'DataBase/DbProvider.dart';

class Repository {
  final moviesApiProvider = MovieApiProvider();
  Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();
  Future<TrailerModel> fetchTrailers(int movieId) =>
      moviesApiProvider.fetchTrailer(movieId);

  Future<int> addToFavorite(FavoriteMovie favoriteModel) =>
      DBProvider.db.addToFavorite(favoriteModel);

  Future<int> deleteFavorite(FavoriteMovie favoriteModel) =>
      DBProvider.db.deleteFavorite(favoriteModel.id);

  Future<FavoriteMovie> getFavoriteMovie(int id) =>
      DBProvider.db.getFavoriteMovie(id);

  Future<bool> isFavorite(int id) => DBProvider.db.isFavorite(id);
}
