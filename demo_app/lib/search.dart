// movie_search_widget.dart
import 'package:demo_app/description_page.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_api/tmdb_api.dart';

class MovieSearchWidget extends StatefulWidget {
  final String apiKey;
  final String readAccessToken;

  MovieSearchWidget({Key? key, required this.apiKey, required this.readAccessToken})
      : super(key: key);

  @override
  _MovieSearchWidgetState createState() => _MovieSearchWidgetState();
}

class _MovieSearchWidgetState extends State<MovieSearchWidget> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _searchMovies(String query) async {
    final tmdb = TMDB(ApiKeys(widget.apiKey, widget.readAccessToken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    final response = await tmdb.v3.search.queryMovies(query);

    if (response.containsKey('results')) {
      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(response['results']);
      });
    } else {
      // Handle error
      print('Error: ${response['status_message']}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Movies',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _searchMovies(_searchController.text);
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final movie = _searchResults[index];
              return ListTile(
                contentPadding: EdgeInsets.all(8.0),
                leading: movie['poster_path'] != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                        width: 48.0,
                        height: 72.0,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 48.0,
                        height: 72.0,
                        color: Colors.grey,
                      ),
                title: Text(movie['title'] ?? ''),
                onTap: () {
                  // Navigate to the MovieDescriptionPage with movie details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDescriptionPage(
                        title: movie['title'] ?? '',
                        posterPath: movie['poster_path'] ?? '',
                        releaseDate: movie['release_date'] ?? '',
                        overview: movie['overview'] ?? '',
                        popularity: (movie['popularity'] ?? 0.0).toDouble(),
                        movie_id: (movie['id']),
                        
                      ),
                    ),
                  );
                },
                // Add more details or customize UI as needed
              );
            },
          ),
        ),
      ],
    );
  }
}
