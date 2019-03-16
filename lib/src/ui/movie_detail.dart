import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hello_bloc/src/blocs/Base/bloc_provider.dart';
import 'package:hello_bloc/src/blocs/movie_detail_bloc.dart';
import 'package:hello_bloc/src/blocs/movie_detail_bloc_provider.dart';
import 'package:hello_bloc/src/blocs/movies_bloc.dart';
import 'package:hello_bloc/src/models/favorite_model.dart';
import 'package:hello_bloc/src/models/trailer_model.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetail extends StatelessWidget {
  final posterUrl;
  final description;
  final releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;

  MovieDetail({
    this.title,
    this.posterUrl,
    this.description,
    this.releaseDate,
    this.voteAverage,
    this.movieId,
  });

  // @override
  // void didChangeDependencies() {
  //   bloc = MovieDetailBlocProvider.of(context);
  //   bloc.fetchTrailersById(movieId);
  //   super.didChangeDependencies();
  // }

  // @override
  // void dispose() {
  //   bloc.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MovieDetailBloc>(context);
    var movieBloc = BlocProvider.of<MoviesBloc>(context);
    movieBloc.isFavorite(movieId);
    bloc.fetchTrailersById(movieId);

    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                  "https://image.tmdb.org/t/p/w500$posterUrl",
                  fit: BoxFit.cover,
                )),
              ),
            ];
          },
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(margin: EdgeInsets.only(top: 5.0)),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 1.0, right: 1.0),
                        ),
                        Text(
                          voteAverage,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        ),
                        Text(
                          releaseDate,
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => movieBloc.addFavorite(
                                new FavoriteModel(
                                    id: this.movieId,
                                    title: this.title,
                                    posterUrl: this.posterUrl)),
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: StreamBuilder<bool>(
                                  stream: movieBloc.favoriteStatus,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshot) {
                                    if (snapshot.hasData) {
                                      return Icon(
                                        Icons.add_to_queue,
                                        color: snapshot.data
                                            ? Colors.red
                                            : Colors.white,
                                      );
                                    } else {
                                      return Icon(
                                        Icons.add_to_queue,
                                        color: Colors.white,
                                      );
                                    }
                                  },
                                )),
                          ),
                        ),
                      ],
                    ),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Text(description),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    Text(
                      "Trailer",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                    StreamBuilder(
                      stream: bloc.movieTrailers,
                      builder: (context,
                          AsyncSnapshot<Future<TrailerModel>> snapshot) {
                        if (snapshot.hasData) {
                          return FutureBuilder(
                            future: snapshot.data,
                            builder: (context,
                                AsyncSnapshot<TrailerModel> itemSnapShot) {
                              if (itemSnapShot.hasData) {
                                if (itemSnapShot.data.results.length > 0)
                                  return trailerLayout(itemSnapShot.data);
                                else
                                  return noTrailer(itemSnapShot.data);
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noTrailer(TrailerModel data) {
    return Center(
      child: Container(
        child: Text("No trailer available"),
      ),
    );
  }

  Widget trailerLayout(TrailerModel data) {
    if (data.results.length > 1) {
      return Row(
        children: <Widget>[
          trailerItem(data, 0),
          trailerItem(data, 1),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          trailerItem(data, 0),
        ],
      );
    }
  }

  trailerItem(TrailerModel data, int index) {
    return Expanded(
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              _launchURL(data.results[index].url);
            },
            child: Container(
              margin: EdgeInsets.all(5.0),
              height: 100.0,
              color: Colors.grey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Icon(Icons.play_circle_filled)),
                  ),
                ],
              ),
            ),
          ),
          Text(
            data.results[index].name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
