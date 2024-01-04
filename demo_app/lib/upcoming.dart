import 'package:flutter/material.dart';
import 'package:demo_app/description_page.dart';

class UpcomingMovies extends StatelessWidget {
  final List upcoming;

  const UpcomingMovies({Key? key, required this.upcoming}) : super(key: key);
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
                itemCount: upcoming.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                          Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDescriptionPage(
                        title: upcoming[index]['title'] ?? '',
                        posterPath: upcoming[index]['poster_path'] ?? '',
                        releaseDate: upcoming[index]['release_date'] ?? '',
                        overview: upcoming[index]['overview'] ?? '',
                        popularity: (upcoming[index]['popularity'] ?? 0.0).toDouble(),
                        movie_id: (upcoming[index]['id']),
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
                                    'https://image.tmdb.org/t/p/w500'+upcoming[index]['poster_path']
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(upcoming[index]['title']!=null?
                              upcoming[index]['title']:'Loading'),
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
