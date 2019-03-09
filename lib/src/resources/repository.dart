import 'package:hello_bloc/src/models/item_model.dart';
import 'package:hello_bloc/src/models/trailer_model.dart';
import 'package:hello_bloc/src/resources/movie_api_provider.dart';

class Repository {
  final moviesApiProvider = MovieApiProvider();
  Future<ItemModel> fetchAllMovies() => moviesApiProvider.fetchMovieList();
  Future<TrailerModel> fetchTrailers(int movieId) =>
      moviesApiProvider.fetchTrailer(movieId);
}
