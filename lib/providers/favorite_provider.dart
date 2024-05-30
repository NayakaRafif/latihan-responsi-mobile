import 'package:flutter/material.dart';
import '../models/meal_detail.dart';

class FavoriteProvider with ChangeNotifier {
  final List<MealDetail> _favoriteMeals = [];

  List<MealDetail> get favoriteMeals => _favoriteMeals;

  void addFavorite(MealDetail meal) {
    _favoriteMeals.add(meal);
    notifyListeners();
  }

  void removeFavorite(MealDetail meal) {
    _favoriteMeals.remove(meal);
    notifyListeners();
  }

  bool isFavorite(MealDetail meal) {
    return _favoriteMeals.contains(meal);
  }
}
