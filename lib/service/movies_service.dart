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
}
