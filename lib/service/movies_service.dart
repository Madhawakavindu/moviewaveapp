//api requests ekak liyanawa

import 'package:flutter_dotenv/flutter_dotenv.dart';

class MoviesService {
  //get the api key from .env
  final String _apikey = dotenv.env["TMDB_DATABASE_KEY"] ?? "";
}
