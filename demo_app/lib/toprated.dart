import 'package:flutter/material.dart';
import 'package:demo_app/description_page.dart';

class TopRatedMovies extends StatelessWidget {
  final List toprated;

  const TopRatedMovies({Key? key, required this.toprated}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Toprated Movies'),
          Container(
            height: 270,
            child: ListView.builder(
                itemCount: toprated.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                          Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDescriptionPage(
                        title: toprated[index]['title'] ?? '',
                        posterPath: toprated[index]['poster_path'] ?? '',
                        releaseDate: toprated[index]['release_date'] ?? '',
                        overview: toprated[index]['overview'] ?? '',
                        popularity: (toprated[index]['popularity'] ?? 0.0).toDouble(),
                        movie_id: (toprated[index]['id']),
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
                                    'https://image.tmdb.org/t/p/w500'+toprated[index]['poster_path']
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Text(toprated[index]['title']!=null?
                              toprated[index]['title']:'Loading'),
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
