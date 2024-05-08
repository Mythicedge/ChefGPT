import 'package:flutter/material.dart';
import '../Data/recipe_model.dart'; 

class RecipeProvider with ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();  
  }

  void removeRecipe(int index) {
    _recipes.removeAt(index);
    notifyListeners();  
  }
}
