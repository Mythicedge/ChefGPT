import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Data/recipe_model.dart';
import 'dart:async';

class RecipeProvider with ChangeNotifier { // Class used to help update UI in real time and class used for the Firestore backend
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;
  
  StreamSubscription? _recipeSubscription;
  StreamSubscription? _authListener;

  RecipeProvider() {
    _authListener = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        print("User is logged in, setting up listener.");
        listenToRecipes();
      } else {
        print("User is logged out, cancelling listener.");
        _recipeSubscription?.cancel();
        _recipes.clear();
        notifyListeners();
      }
    });
  }

  void listenToRecipes() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _recipeSubscription?.cancel();  // Prevent multiple subscriptions
      _recipeSubscription = FirebaseFirestore.instance
        .collection('users').doc(uid).collection('recipes')
        .snapshots().listen((snapshot) {
          _recipes = snapshot.docs.map((doc) => Recipe.fromMap({
            ...doc.data() as Map<String, dynamic>,
            'id': doc.id,
          })).toList();
          notifyListeners();
        }, onError: (error) {
          print("Error listening to recipe updates: $error");
        });
    }
  }

  @override
  void dispose() {
    _authListener?.cancel();
    _recipeSubscription?.cancel();
    super.dispose();
  }


  
  Future<void> fetchRecipes() async { // Fetch recipes from Firestore
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    print("No UID found");
    return;
  }
  try {
    var collection = FirebaseFirestore.instance.collection('users').doc(uid).collection('recipes');
    var snapshot = await collection.get();
    _recipes = snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; 
      return Recipe.fromMap(data);
    }).toList();
    print("Fetched ${_recipes.length} recipes with IDs");
    notifyListeners();
  } catch (e) {
    print("Failed to fetch recipes: $e");
  }
}



 
Future<void> addRecipe(Recipe recipe) async {  // Add a recipe to Firestore and local list
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    print("User ID is not available.");
    return;
  }
  try {
    var collection = FirebaseFirestore.instance.collection('users').doc(uid).collection('recipes');
    var docRef = await collection.add(recipe.toMap()); 
  
   
    Recipe newRecipe = Recipe(  // Create new recipes for Firestore
      id: docRef.id,
      title: recipe.title,
      ingredients: recipe.ingredients,
      description: recipe.description,
      imageUrl: recipe.imageUrl,
    );

    _recipes.add(newRecipe);
    notifyListeners();
    await fetchRecipes(); // Fetch all recipes again to update the UI
  } catch (e) {
    print("Failed to add recipe: $e");
  }
}



  // Remove recipe from Firestore and local list
  Future<void> removeRecipe(String recipeId) async {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    await FirebaseFirestore.instance.collection('users').doc(uid).collection('recipes').doc(recipeId).delete();
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
    notifyListeners();
  }
}


}
