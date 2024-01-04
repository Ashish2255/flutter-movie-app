import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
    required this.movie_id
  });

  final apiKey = 'f6af47f887c6773f90dcb685a8200e13';
  Future<void> storeSessionIdWithUserProfile(
      String userId, String sessionId) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    await userDoc.set({
      'tmdb_session_id': sessionId,
      // Other user profile data as needed
    }, SetOptions(merge: true));
  }

  Future<String> createRequestToken(String apiKey) async {
    final url = 'https://api.themoviedb.org/3/authentication/token/new';
    final response = await http.get(Uri.parse('$url?api_key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['request_token'];
    } else {
      // Handle error
      print('Error creating request token: ${response.body}');
      throw Exception('Failed to create request token');
    }
  }

  void openAuthenticationUrl(String requestToken) async {
    final authenticationUrl =
        'https://www.themoviedb.org/authenticate/$requestToken';
    if (await canLaunch(authenticationUrl)) {
      await launch(authenticationUrl);
    } else {
      // Handle error
      print('Error launching authentication URL');
    }
  }

  Future<String> createSessionId(
      String apiKey, String approvedRequestToken) async {
    final url = 'https://api.themoviedb.org/3/authentication/session/new';
    final response = await http.post(
      Uri.parse('$url?api_key=$apiKey'),
      body: jsonEncode({'request_token': approvedRequestToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['session_id'];
    } else {
      // Handle error
      print('Error creating session ID: ${response.body}');
      throw Exception('Failed to create session ID');
    }
  }

  Future<String?> getTmdbSessionId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String? tmdbSessionId = userDoc['tmdb_session_id'];

      if (tmdbSessionId == null) {
        // If session ID is not available, create a new one
        tmdbSessionId = await createTmdbSessionId();
        // Store the new session ID in Firestore
        await storeSessionIdWithUserProfile(user.uid, tmdbSessionId);
      }

      return tmdbSessionId;
    }
    return null;
  }

  Future<String> createTmdbSessionId() async {
    final apiKey = 'f6af47f887c6773f90dcb685a8200e13';
    final requestToken = await createRequestToken(apiKey);

    // Redirect user to TMDb authentication URL and obtain approval

    // Assuming the user has approved the request token, proceed to create session ID
    return await createSessionId(apiKey, requestToken);
  }

  Future<int> getAccountId(String apiKey, String tmdbSessionId) async {
    final url = 'https://api.themoviedb.org/3/account';
    final response = await http.get(
      Uri.parse('$url?api_key=$apiKey&session_id=$tmdbSessionId'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['id'];
    } else {
      // Handle error
      print('Error getting account ID: ${response.body}');
      throw Exception('Failed to get account ID');
    }
  }

  Future<void> addToFavorites(String apiKey, String tmdbSessionId, int movieId) async {
    final accountid=getAccountId(apiKey, tmdbSessionId);
    final url = 'https://api.themoviedb.org/3/account/$accountid/favorite';

    // Replace {account_id} with the user's TMDb account ID
    // You can obtain the account ID from the user's TMDb account information

    final response = await http.post(
      Uri.parse('$url?api_key=$apiKey&session_id=$tmdbSessionId'),
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': true,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      // Movie successfully added to favorites
      print('Movie added to favorites successfully');
    } else {
      // Handle error
      print('Error adding movie to favorites: ${response.body}');
      throw Exception('Failed to add movie to favorites');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // Get the TMDb session ID
                final tmdbSessionId = await getTmdbSessionId();

                // Check if session ID is available
                if (tmdbSessionId != null) {
                  // Add the movie to favorites
                  await addToFavorites(apiKey, tmdbSessionId, movie_id);

                  // Show a success message or update UI as needed
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to favorites successfully!'),
                    ),
                  );
                } else {
                  // Handle the case where TMDb session ID is not available
                  print('TMDb session ID is not available.');
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
