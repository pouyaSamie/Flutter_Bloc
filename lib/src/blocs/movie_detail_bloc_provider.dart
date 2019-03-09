import 'package:flutter/material.dart';
import 'package:hello_bloc/src/blocs/movie_detail_bloc.dart';

class MovieDetailBlocProvider extends InheritedWidget {
  final MovieDetailBloc bloc;
  MovieDetailBlocProvider({Key key, this.child})
      : bloc = MovieDetailBloc(),
        super(key: key, child: child);

  final Widget child;

  static MovieDetailBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(MovieDetailBlocProvider)
            as MovieDetailBlocProvider)
        .bloc;
  }

  @override
  bool updateShouldNotify(MovieDetailBlocProvider oldWidget) {
    return true;
  }
}
