import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:demo_app/description_page.dart';

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
  return Container(
    padding: EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Watchlist Movies'),
        Container(
          height: 270,
          child: ListView.builder(
            itemCount: _movieInfoMap.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final movieId = _movieInfoMap.keys.elementAt(index);
              final movieDetails = _movieInfoMap[movieId];
              if (movieDetails != null) {
                return InkWell(
                  onTap: () {
                    // Navigate to movie description page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDescriptionPage(
                          title: movieDetails['title'] ?? '',
                          posterPath: movieDetails['poster_path'] ?? '',
                          releaseDate: movieDetails['release_date'] ?? '',
                          overview: movieDetails['overview'] ?? '',
                          popularity: (movieDetails['popularity'] ?? 0.0).toDouble(),
                          movie_id: movieId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    child: Column(
                      children: [
                        Container(
                          height: 210,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${movieDetails['poster_path']}',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Text(movieDetails['title'] ?? 'Loading'),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                // Handle case when movie details are not available
                return SizedBox.shrink(); // Empty widget
              }
            },
          ),
        )
      ],
    ),
  );
}

}
