import 'package:flutter/material.dart';
import 'package:demo_app/models/user_models.dart'; // Import your UserModel class
import 'package:demo_app/repository/user_repo.dart'; // Import your UserRepository class
import 'package:demo_app/watchlist.dart';
import 'package:demo_app/search_page.dart';
import 'package:demo_app/main.dart';
class ProfilePage extends StatefulWidget {
  final String? email;

  ProfilePage({this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<UserModel> _userDetailsFuture;
  final UserRepository _userRepository = UserRepository.instance;
  String userEmail = getCurrentUserEmail();
  int _currentIndex = 1;
  @override
  void initState() {
    super.initState();
    _userDetailsFuture = _userRepository.getUserDetails(widget.email ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<UserModel>(
        future: _userDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching user details'));
          } else {
            UserModel user = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${user.email}'),
                  SizedBox(height: 8.0),
                  Text('Password: ${user.password}'),
                  SizedBox(height: 8.0),
                  Text('Watchlist:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                  // Use WatchlistMovies widget to display watchlist movies
                  Expanded(
                    child: WatchlistMovies(watchlist: user.watchlist),
                  ),
                  // Add more user details here if needed
                ],
              ),
            );
          }
        },
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
