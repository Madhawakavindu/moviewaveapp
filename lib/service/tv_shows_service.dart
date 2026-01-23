import 'dart:convert';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:moviewave/models/tv_show_model.dart';

class TvShowsService {
  // api key
  final String _apikey = dotenv.env['TMDB_DATABASE_KEY'] ?? "";

  Future<List<dynamic>> fetchTvShows() async {
    try {
      // base url
      final String BaseUrl = "https://api.themoviedb.org/3";
      //popular tv shows
      final popularResponse = await http.get(
        Uri.parse("$BaseUrl/tv/popular?api_key=$_apikey"),
      );

      //airing today tv shows
      final airingTodayResponse = await http.get(
        Uri.parse("$BaseUrl/tv/top_rated?api_key=$_apikey"),
      );

      //top rated tv shows
      final topRatedResponse = await http.get(
        Uri.parse("$BaseUrl/tv/top_rated?api_key=$_apikey"),
      );
      if (popularResponse.statusCode == 200 &&
          airingTodayResponse.statusCode == 200 &&
          topRatedResponse.statusCode == 200) {
        final popularData = json.decode(popularResponse.body);
        final airingData = json.decode(airingTodayResponse.body);
        final topRatedData = json.decode(topRatedResponse.body);

        final List<dynamic> popularResult = popularData['results'];
        final List<dynamic> airingResult = airingData['results'];
        final List<dynamic> topRatedResult = topRatedData['results'];

        List<TvShow> tvShows = [];

        tvShows.addAll(
          popularResult.map((tvData) => TvShow.fromJson(tvData)).take(10),
        );
        tvShows.addAll(
          airingResult.map((tvData) => TvShow.fromJson(tvData)).take(10),
        );
        tvShows.addAll(
          topRatedResult.map((tvData) => TvShow.fromJson(tvData)).take(10),
        );

        return tvShows;
      } else {
        throw Exception("Failed to load TV shows");
      }
    } catch (error) {
      print("Error fetching tv shows: $error");
      return [];
    }
  }
}
