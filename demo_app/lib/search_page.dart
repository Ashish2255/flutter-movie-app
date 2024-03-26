import 'package:flutter/material.dart';
import 'search.dart'; // Import the MovieSearchWidget
import 'package:demo_app/main.dart';
import 'package:demo_app/profile/profile_page.dart';
class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String userEmail = getCurrentUserEmail();

  int _currentIndex = 2;

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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle navigation to different tabs
          setState(() {
            _currentIndex = index;
          });
          if(index==0){
            Navigator.pushReplacementNamed(context, '/home');
          }
          else if(index==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(email: userEmail)),
            );
          }
          else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          }
        },
      ),
    );
  }
}