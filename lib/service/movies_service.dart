//api requests ekak liyanawa
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moviewave/models/movie_mode.dart';

class MoviesService {
  //get the api key from .env
  final String _apikey = dotenv.env["TMDB_DATABASE_KEY"] ?? "";

  final String _baseUrl = "https://api.themoviedb.org/3/movie";

  //fetch all upcomming movies(function eka)
  Future<List<Movie>> fetchUpcommingMovies({int page = 1}) async {
    try {
      final responce = await http.get(
        Uri.parse("$_baseUrl/upcoming?api_key=$_apikey&page=$page"),
      );
      // responce ek hriyt awd kiyl check krgnn
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Faild to load the data");
      }
    } catch (error) {
      print("Error fetching upcomming movies $error");
      return [];
    }
  }

  //fetch all now playing movies
  Future<List<Movie>> fetchNowPlayingMovies({int page = 1}) async {
    try {
      final responce = await http.get(
        Uri.parse("$_baseUrl/now_playing?api_key=$_apikey&page=$page"),
      );

      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Error fetching now playing movies");
      }
    } catch (error) {
      print("Error fetchin now playing movies:$error");
      return [];
    }
  }
  //search movie
  //https://api.themoviedb.org/3/search/movie?query=Avengers&api_key=b946d50855df63946e74fae9bdcb49d3

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final responce = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/search/movie?query=$query&api_key=$_apikey',
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Error Searching movies");
      }
    } catch (error) {
      print("Error searching movies: $error");
      throw Exception("Faild to search movies:$error");
    }
  }

  //similar movies
  //https://api.themoviedb.org/3/movie/299536/similar?api_key=b946d50855df63946e74fae9bdcb49d3
  Future<List<Movie>> fetchSimilarMovies(int movieId) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$_apikey",
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Faild to fetch similar movies");
      }
    } catch (error) {
      print("Faild to fetch similar movies: $error");
      return [];
    }
  }

  //recommended movies
  //https://api.themoviedb.org/3/movie/299536/recommendations?api_key=b946d50855df63946e74fae9bdcb49d3
  Future<List<Movie>> fetchRecommendedMovies(int movieId) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/recommendations?api_key=$_apikey",
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> results = data["results"];

        return results.map((movieData) => Movie.fromJson(movieData)).toList();
      } else {
        throw Exception("Faild to fetch recommended movies");
      }
    } catch (error) {
      print("Faild to fetch recommended movies: $error");
      return [];
    }
  }

  //fetch images by movie ID
  Future<List<String>> fetchImageFromMovieId(int movieId) async {
    try {
      final responce = await http.get(
        Uri.parse(
          "https://api.themoviedb.org/3/movie/$movieId/images?api_key=$_apikey,",
        ),
      );
      if (responce.statusCode == 200) {
        final data = json.decode(responce.body);
        final List<dynamic> backdrops = data["backdrops"];

        //extract file paths and return the first 10 images

        return backdrops
            .take(10)
            .map(
              (imageData) =>
                  "https://image.tmdb.org/t/p/w500${imageData["file_path"]}",
            )
            .toList();
      } else {
        throw Exception("Failed to fetch images");
      }
    } catch (error) {
      print("Error fetching images: $error");

      return [];
    }
  }
}
