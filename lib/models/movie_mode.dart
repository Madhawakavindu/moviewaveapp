class Movie {
  final bool adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  // method to convert the JSON data into a dart object

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(adult: adult, genreIds: genreIds, id: id, originalLanguage: originalLanguage, originalTitle: originalTitle, overview: overview, popularity: popularity, releaseDate: releaseDate, title: title, video: video, voteAverage: voteAverage, voteCount: voteCount):
  }
}
