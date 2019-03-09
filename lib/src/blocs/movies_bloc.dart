import 'package:hello_bloc/src/models/item_model.dart';
import 'package:hello_bloc/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class MoviesBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();

  Observable<ItemModel> get allMovies => _moviesFetcher.stream;

  void fetchAllMovies() async {
    ItemModel itemModels = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModels);
  }

  void dispose() {
    _moviesFetcher.close();
  }
}

final bloc = MoviesBloc();
