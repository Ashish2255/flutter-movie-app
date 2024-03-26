import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

class WatchlistMovies extends StatefulWidget {
  final List<int> watchlist;

  const WatchlistMovies({Key? key, required this.watchlist}) : super(key: key);

  @override
  _WatchlistMoviesState createState() => _WatchlistMoviesState();
}

class _WatchlistMoviesState extends State<WatchlistMovies> {
  Map<int, Map<dynamic, dynamic>> _movieInfoMap = {};
  bool _isLoading = true;
  
  
  @override
  void initState() {
    super.initState();
    fetchMovieInfo();
  }
  TMDB tmdbWithCustomLogs = TMDB(ApiKeys('f6af47f887c6773f90dcb685a8200e13','eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNmFmNDdmODg3YzY3NzNmOTBkY2I2ODVhODIwMGUxMyIsInN1YiI6IjY1ODMzMzJmZmJlMzZmNGFkYzdmMThhNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.orVnXoYOE3M4sEaFbIclisjDJ-eCDIf9UP_A3dOFHeI'),
    logConfig:ConfigLogger(
      showLogs: true,
      showErrorLogs: true,
    ) );
  Future<void> fetchMovieInfo() async {
    for (int id in widget.watchlist) {
      var info = await tmdbWithCustomLogs.v3.movies.getDetails(id); // Fetch movie info using tmdb API
      setState(() {
        _movieInfoMap[id] = info;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: widget.watchlist.length,
            itemBuilder: (context, index) {
              int id = widget.watchlist[index];
              Map<dynamic, dynamic>? info = _movieInfoMap[id];
              if (info != null) {
                return ListTile(
                  title: Text(info['title'] ?? 'Unknown Title'),
                  subtitle: Text(info['overview'] ?? 'No Overview Available'),
                  
                  // Add more details as needed
                );
              } else {
                return ListTile(
                  title: Text('Loading...'),
                );
              }
            },
          );
  }
}
