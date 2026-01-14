import 'package:flutter/material.dart';
import 'package:moviewave/models/movie_mode.dart';
import 'package:moviewave/service/movies_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Movie> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  //the method to fetch the upcomming movies from the API and this method is called in the initState method.

  Future<void> _fetchMovies() async {
    if (_isLoading || !_hasMore) {
      return;
    }
    setState(() {
      //loading state ekak pennanna oni e nisa
      _isLoading = true;
    });
    // eka digata scroll karanawa nam user kenek podi delayed time ekk denw
    await Future.delayed(const Duration(seconds: 1));
    // dan data tika fetch krgamu
    try {
      final newMovies = await MoviesService().fetchUpcommingMovies(
        page: _currentPage,
      );
      print(newMovies.length);
      setState(() {
        if (newMovies.isEmpty) {
          _hasMore = false;
        } else {
          _movies.addAll(newMovies);
          _currentPage++;
        }
      });
    } catch (error) {
      print("Error:$error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MovieWave",
          style: TextStyle(
            fontSize: 24,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (!_isLoading &&
              notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
            _fetchMovies();
          }
          return false;
        },

        child: ListView.builder(
          itemCount: _movies.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _movies.length) {
              return const Center(child: CircularProgressIndicator());
              ;
            }
            return ListTile(title: Text(_movies[index].title.toString()));
          },
        ),
      ),
    );
  }
}
