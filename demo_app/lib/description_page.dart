import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:demo_app/repository/user_repo.dart';
import 'package:demo_app/main.dart';
class MovieDescriptionPage extends StatelessWidget {
  final String title;
  final String posterPath;
  final String releaseDate;
  final String overview;
  final double popularity;
  final int movie_id;
  
  MovieDescriptionPage({
    required this.title,
    required this.posterPath,
    required this.releaseDate,
    required this.overview,
    required this.popularity,
    required this.movie_id,
    
  });

  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    String userEmail = getCurrentUserEmail();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              'https://image.tmdb.org/t/p/w300$posterPath',
              width: 200.0, // Adjust the width as needed
              height: 300.0, // Adjust the height as needed
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text('Release Date: $releaseDate'),
            SizedBox(height: 8.0),
            Text('Overview: $overview'),
            SizedBox(height: 8.0),
            Text('Popularity: $popularity'),
            ElevatedButton(
              onPressed: () async {
                //appendStringToWatchlist(, );
                
                    try {
                      // Example: appending a string "newValue" to the watchlist of user with email "user@example.com"
                      await _userRepository.appendStringToWatchlist(userEmail, movie_id);
                      print("String appended to watchlist successfully.");
                    } catch (error) {
                      print("Error appending string to watchlist: $error");
                      // Handle error
                    }
                  
              },
              child: Text('Add to Favorites'),
            ),
          ],
        ),
      ),
    );
  }
}
