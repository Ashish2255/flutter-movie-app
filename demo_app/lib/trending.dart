import 'package:flutter/material.dart';
import 'package:demo_app/description_page.dart';

class TrendingMovies extends StatelessWidget {
  final List trending;

  const TrendingMovies({Key? key, required this.trending}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trending Movies'),
          Container(
            height: 270,
            child: ListView.builder(
                itemCount: trending.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDescriptionPage(
                        title: trending[index]['title'] ?? '',
                        posterPath: trending[index]['poster_path'] ?? '',
                        releaseDate: trending[index]['release_date'] ?? '',
                        overview: trending[index]['overview'] ?? '',
                        popularity: (trending[index]['popularity'] ?? 0.0).toDouble(),
                        movie_id: (trending[index]['id']),
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
                                    'https://image.tmdb.org/t/p/w500'+trending[index]['poster_path']
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(trending[index]['title']!=null?
                              trending[index]['title']:'Loading'),
                            ),
                          ],
                        ),
                      ));
                }),
          )
        ],
      ),
    );
  }
}
