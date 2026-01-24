import 'package:flutter/material.dart';
import 'package:moviewave/models/movie_mode.dart';
import 'package:moviewave/service/movies_service.dart';
import 'package:moviewave/widgets/search_detail.dart';

class SingleMoveDetailsPage extends StatefulWidget {
  Movie movie;
  SingleMoveDetailsPage({super.key, required this.movie});

  @override
  State<SingleMoveDetailsPage> createState() => _SingleMoveDetailsPageState();
}

class _SingleMoveDetailsPageState extends State<SingleMoveDetailsPage> {
  List<Movie> _similarMovies = [];
  List<Movie> _recommendedMovies = [];
  List<String> _movieImages = [];

  bool _isLoading = true;
  bool _isLoadingRecommenede = true;
  bool _isLoadingImages = true;

  //Fetch similar movies
  Future<void> _fetchSimilarMovies() async {
    try {
      List<Movie> fetchMovies = await MoviesService().fetchSimilarMovies(
        widget.movie.id,
      );
      setState(() {
        _similarMovies = fetchMovies;
        _isLoading = false;
      });
    } catch (error) {
      print("Error from similar: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  //Fetch recommended movies
  Future<void> _fetchRecommendedMovies() async {
    try {
      List<Movie> fetchMovies = await MoviesService().fetchRecommendedMovies(
        widget.movie.id,
      );
      setState(() {
        _recommendedMovies = fetchMovies;
        _isLoadingRecommenede = false;
      });
    } catch (error) {
      print("Error from similar: $error");
      setState(() {
        _isLoadingRecommenede = false;
      });
    }
  }

  //Fetch  movis images
  Future<void> _fetchMovieImages() async {
    try {
      List<String> fetchedImages = await MoviesService().fetchImageFromMovieId(
        widget.movie.id,
      );
      setState(() {
        _movieImages = fetchedImages;
        _isLoadingImages = false;
      });
    } catch (error) {
      print("Error from similar: $error");
      setState(() {
        _isLoadingImages = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovieImages();
    _fetchRecommendedMovies();
    _fetchSimilarMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.movie.title)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchWidget(movie: widget.movie),
              SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.all(8.0),

                child: Text(
                  'Movie Images',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildImageSection(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Similar Movies',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildMovieSection(_similarMovies, _isLoading),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Recommended Movies',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _buildMovieSection(_recommendedMovies, _isLoadingRecommenede),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    if (_isLoadingImages) {
      return Center(child: CircularProgressIndicator());
    }
    if (_movieImages.isEmpty) {
      return const Center(child: Text("No Images Found"));
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(4),
            width: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(_movieImages[index], fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieSection(List<Movie> movies, bool isLoading) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (movies.isEmpty) {
      return const Center(child: Text("No Movies Found"));
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: movies.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          //movie ekak click karala ena movie ekath click karann
          return GestureDetector(
            onTap: () {
              setState(() {
                widget.movie = movies[index];
                _fetchMovieImages();
                _fetchRecommendedMovies();
                _fetchSimilarMovies();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.all(4.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (movies[index].posterPath != null)
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movies[index].posterPath}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 100,
                      child: Text(
                        movies[index].title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    Text(
                      'Average Vote: ${movies[index].voteAverage}',
                      style: TextStyle(fontSize: 7, color: Colors.red[600]),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
