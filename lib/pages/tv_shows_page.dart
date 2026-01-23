import 'package:flutter/material.dart';
import 'package:moviewave/models/tv_show_model.dart';
import 'package:moviewave/service/tv_shows_service.dart';
import 'package:moviewave/widgets/tv_show_widget.dart';

class TvShowsPage extends StatefulWidget {
  const TvShowsPage({super.key});

  @override
  State<TvShowsPage> createState() => _TvShowsPageState();
}

class _TvShowsPageState extends State<TvShowsPage> {
  List<TvShow> _tvShows = [];
  bool _isLoading = true;
  String _error = "";

  //fetch tv shows
  Future<void> _fetchTvShows() async {
    try {
      List<TvShow> tvShows = (await TvShowsService().fetchTvShows())
          .cast<TvShow>();

      setState(() {
        _tvShows = tvShows;
        _isLoading = false;
      });
    } catch (error) {
      print("Error:$error");
      setState(() {
        _error = "Failed to load tv shows";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TV Shows")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _tvShows.isEmpty
          ? Center(child: Text("No TV Shows found"))
          : ListView.builder(
              itemCount: _tvShows.length,
              itemBuilder: (context, index) {
                //final tvShow = _tvShows[index];
                return TvShowWidget(tvShow: _tvShows[index]);
              },
            ),
    );
  }
}
