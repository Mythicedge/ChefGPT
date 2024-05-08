import 'package:flutter/material.dart';
import 'RecipePage.dart';
import 'SavedPage.dart';
import 'ExplorePage.dart';
import 'ProfilePage.dart';
import '../Data/recipe_model.dart';  // Ensure this is correctly imported

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Recipe> savedRecipes = [];  // Centralized list of saved recipes
  late List<Widget> _pages;  // Declare _pages here without initializing

  @override
  void initState() {
    super.initState();
    // Initialize _pages here in initState
    _pages = [
      RecipePage(savedRecipes: savedRecipes),
      SavedPage(savedRecipes: savedRecipes),
      ExplorePage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Recipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
