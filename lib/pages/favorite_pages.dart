import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/favorite_provider.dart';
import '../pages/detail_pages.dart';

class FavoritePage extends StatelessWidget {
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
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.data == false) {
            return Scaffold(
              body: Center(
                child: Text('Please login to view this page.'),
              ),
            );
          } else {
            final favoriteMeals = context.watch<FavoriteProvider>().favoriteMeals;

            return Scaffold(
              appBar: AppBar(
                title: Text('Favorite Meals'),
              ),
              body: ListView.builder(
                itemCount: favoriteMeals.length,
                itemBuilder: (context, index) {
                  final meal = favoriteMeals[index];
                  return ListTile(
                    leading: Image.network(meal.strMealThumb, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(meal.strMeal),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(mealId: meal.idMeal),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        }
      },
    );
  }
}
