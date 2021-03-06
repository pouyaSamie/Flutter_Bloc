import 'package:flutter/material.dart';
import 'package:hello_bloc/src/blocs/Base/bloc_provider.dart';
import 'package:hello_bloc/src/blocs/movies_bloc.dart';
import 'package:hello_bloc/src/ui/movie_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MoviesBloc>(
      bloc: MoviesBloc(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(body: MovieList()),
      ),
    );
  }
}
