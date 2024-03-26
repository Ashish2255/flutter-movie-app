//import 'package:demo_app/search.dart';
import 'package:demo_app/profile/profile_page.dart';
import 'package:demo_app/search_page.dart';
import 'package:demo_app/toprated.dart';
import 'package:demo_app/trending.dart';
import 'package:demo_app/upcoming.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:demo_app/models/user_models.dart';
import 'package:demo_app/repository/user_repo.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
void main() async{
  //WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid 
    ? await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: 'AIzaSyCXzrx4JdkB-suAZeqIwxj4BBI50pMUdlU',
        appId: "1:892377282506:android:2127501c51977d700f8133", 
        messagingSenderId: "892377282506", 
        projectId: "fir-app-1-fbc9f"),
    )
    :await Firebase.initializeApp();
  
  Get.put(UserRepository());
  runApp(MyApp());
  
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignInScreen(),
        '/home': (context) => HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}

class SignInScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Log In'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";

  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      // Handle login errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _signIn();
                  }
                },
                child: Text('Log In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  String _reconfirmPassword = "";

  Future<void> _register() async {
    try {
      // Check if the user already exists
      UserCredential existingUser = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // User successfully registered, log in automatically
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
        
      );
      List<int> _watchlist = [];
      // Create UserModel instance
      UserModel user = UserModel(
        email: _email,
        password: _password,
        watchlist: _watchlist
      );

      // Get instance of UserRepository
      UserRepository userRepository = UserRepository.instance;

      // Store user in Firestore
      await userRepository.createUser(user);
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
      // Handle registration errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Reconfirm Password'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please re-enter your password';
                  } //else if (value != _password) {
                  //   return 'Passwords do not match';
                  // }
                  return null;
                },
                onSaved: (value) => _reconfirmPassword = value!,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _register();
                  }
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;
  List trendingmovies = [];
  List topratedmovies = [];
  List upcomingmovies = [];
  
  final String apiKey = 'f6af47f887c6773f90dcb685a8200e13';
  final String readaccesstoken = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNmFmNDdmODg3YzY3NzNmOTBkY2I2ODVhODIwMGUxMyIsInN1YiI6IjY1ODMzMzJmZmJlMzZmNGFkYzdmMThhNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.orVnXoYOE3M4sEaFbIclisjDJ-eCDIf9UP_A3dOFHeI';
  
  @override
  void initState(){
    loadmovies();
    super.initState();
  }

  loadmovies()async{
    TMDB tmdbWithCustomLogs = TMDB(ApiKeys(apiKey, readaccesstoken),
    logConfig:ConfigLogger(
      showLogs: true,
      showErrorLogs: true,
    ) );
    Map trendingresult=await tmdbWithCustomLogs.v3.trending.getTrending();
    Map topratedresult=await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map upcomingresult=await tmdbWithCustomLogs.v3.movies.getUpcoming();

    setState(() {
      trendingmovies =  trendingresult['results'];
      topratedmovies = topratedresult['results'];
      upcomingmovies = upcomingresult['results'];
    });
    print(trendingmovies);
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Text('Welcome, ${_auth.currentUser!.email}!'),
          TrendingMovies(trending:trendingmovies),
          TopRatedMovies(toprated:topratedmovies),
          UpcomingMovies(upcoming: upcomingmovies),
        ]
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
          if(index==1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(email: _auth.currentUser!.email)),
            );
          }
          if (index == 2) {
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
String getCurrentUserEmail() {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Assuming _auth is your FirebaseAuth instance
  return _auth.currentUser!.email!;
}