import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import 'package:coba/pages/detail_pages.dart';

class MealsPage extends StatelessWidget {
  final String category;

  MealsPage({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meals'),
      ),
      body: FutureBuilder<List<Meal>>(
        future: ApiService().fetchMeals(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            final meals = snapshot.data!;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                return ListTile(
                  leading: Image.network(meal.strMealThumb),
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
            );
          }
        },
      ),
    );
  }
}
