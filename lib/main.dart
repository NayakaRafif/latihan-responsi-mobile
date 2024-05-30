import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/favorite_provider.dart';
import 'pages/detail_pages.dart';
import 'pages/favorite_pages.dart';
import 'pages/login_pages.dart';
import 'pages/register_pages.dart';
import 'pages/category_pages.dart';
import 'pages/profile_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],
      child: MaterialApp(
        title: 'Meal App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthCheck(),
        routes: {
          '/favorites': (context) => FavoritePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            return CategoryPage();
          } else {
            return LoginPage();
          }
        }
      },
    );
  }
}
