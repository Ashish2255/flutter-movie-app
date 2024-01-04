import 'package:flutter/material.dart';
import 'search.dart'; // Import the MovieSearchWidget

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Movies'),
      ),
      body: MovieSearchWidget(
        apiKey: 'f6af47f887c6773f90dcb685a8200e13', // Replace with your actual API key
        readAccessToken: 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNmFmNDdmODg3YzY3NzNmOTBkY2I2ODVhODIwMGUxMyIsInN1YiI6IjY1ODMzMzJmZmJlMzZmNGFkYzdmMThhNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.orVnXoYOE3M4sEaFbIclisjDJ-eCDIf9UP_A3dOFHeI', // Replace with your actual read access token
      ),
    );
  }
}