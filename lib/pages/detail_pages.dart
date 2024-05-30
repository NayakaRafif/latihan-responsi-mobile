import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/meal_detail.dart';
import '../providers/favorite_provider.dart';

class DetailPage extends StatelessWidget {
  final String mealId;

  DetailPage({required this.mealId});

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
            return Scaffold(
              appBar: AppBar(
                title: Text('Meal Detail'),
              ),
              body: FutureBuilder<MealDetail>(
                future: ApiService().fetchMealDetail(mealId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final mealDetail = snapshot.data!;
                    final isFavorite = context.watch<FavoriteProvider>().isFavorite(mealDetail);
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(mealDetail.strMealThumb),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  mealDetail.strMeal,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    final favoriteProvider = context.read<FavoriteProvider>();
                                    if (isFavorite) {
                                      favoriteProvider.removeFavorite(mealDetail);
                                    } else {
                                      favoriteProvider.addFavorite(mealDetail);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Category: ${mealDetail.strCategory}', style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Area: ${mealDetail.strArea}', style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Instructions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(mealDetail.strInstructions, style: TextStyle(fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Ingredients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          for (int i = 0; i < mealDetail.ingredients.length; i++)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                              child: Text('${mealDetail.ingredients[i]} - ${mealDetail.measures[i]}'),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('YouTube', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () => _launchURL(mealDetail.strYoutube),
                              child: Text(
                                mealDetail.strYoutube,
                                style: TextStyle(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            );
          }
        }
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
