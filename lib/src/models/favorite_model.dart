import 'dart:convert';

class FavoriteMovie {
  int id;
  String title;
  String posterUrl;

  FavoriteMovie({this.id, this.title, this.posterUrl});

  Map<String, dynamic> toJson() => {
        "id": id,
        "movie_title": title,
        "poster_path": posterUrl,
      };
  factory FavoriteMovie.fromJson(Map<String, dynamic> json) =>
      new FavoriteMovie(
          id: json["id"],
          title: json["movie_title"],
          posterUrl: json["poster_path"]);

  String favoriteMovieToJson(FavoriteMovie data) {
    final dyn = data.toJson();
    return json.encode(dyn);
  }

  FavoriteMovie favoriteMovieFromJson(String str) {
    final jsonData = json.decode(str);
    return FavoriteMovie.fromJson(jsonData);
  }
}
