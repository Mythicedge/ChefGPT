import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _preLoadedRecipes = [];
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _loadDefaultRecipes();
  }

  void _loadDefaultRecipes() async {
    try {
      const apiKey = '7ea5aa4a8c404f179e74a9d0f0dc0896';
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/random?number=35&apiKey=$apiKey'));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> recipes =
            (jsonDecode(response.body)['recipes'] as List)
                .cast<Map<String, dynamic>>();
        final List<Future<Map<String, dynamic>>> recipeDetailsFutures =
            recipes.map((recipe) => _fetchRecipeDetails(recipe['id'])).toList();
        final List<Map<String, dynamic>> recipeDetails =
            await Future.wait(recipeDetailsFutures);
        setState(() {
          _preLoadedRecipes = recipeDetails;
          _searchResults = List.from(_preLoadedRecipes);
        });
      } else {
        throw Exception(
            'Failed to load default recipes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading default recipes: $e');
    }
  }

  Future<Map<String, dynamic>> _fetchRecipeDetails(int recipeId) async {
    try {
      const apiKey = '7ea5aa4a8c404f179e74a9d0f0dc0896';
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/$recipeId/information?apiKey=$apiKey'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to fetch recipe details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching recipe details: $e');
      return {};
    }
  }

  void _searchRecipes(String query) async {
    if (query.isNotEmpty) {
      const apiKey = '7ea5aa4a8c404f179e74a9d0f0dc0896';
      final response = await http.get(Uri.parse(
          'https://api.spoonacular.com/recipes/search?query=$query&apiKey=$apiKey'));
      if (response.statusCode == 200) {
        setState(() {
          _searchResults = (jsonDecode(response.body)['results'] as List)
              .cast<Map<String, dynamic>>()
              .where((recipe) =>
                  recipe['image'] != null &&
                  recipe['image'].toString().isNotEmpty)
              .toList();
        });
      } else {
        throw Exception(
            'Failed to load search results: ${response.statusCode}');
      }
    } else {
      setState(() {
        _searchResults = List.from(_preLoadedRecipes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Various Recipes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _searchRecipes(_searchQuery);
              },
              decoration: InputDecoration(
                hintText: 'Search various recipes...',
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchRecipes(_searchQuery);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: _searchQuery.isNotEmpty
                        ? const Text('No recipes found')
                        : const CircularProgressIndicator(),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final recipe = _searchResults[index];
                      final imageUrl = recipe['image'] as String?;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailPage(
                                recipe: recipe,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: imageUrl != null &&
                                        Uri.parse(imageUrl).isAbsolute
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : const Placeholder(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  recipe['title'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  List<String> _parseInstructions(String instructions) {
    // Remove HTML tags from instructions
    String cleanedInstructions =
        instructions.replaceAll(RegExp(r'<[^>]*>'), '');
    // Replace special characters
    cleanedInstructions = cleanedInstructions
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&rsquo;', '\''); // Example: Replace &rsquo; with '
    // Split instructions into a list
    List<String> instructionList = cleanedInstructions.split(RegExp(r'\.\s*'));
    // Remove empty instructions
    instructionList =
        instructionList.where((instruction) => instruction.isNotEmpty).toList();
    // Add numbering to instructions
    instructionList = instructionList
        .asMap()
        .entries
        .map((entry) => '${entry.key + 1}. ${entry.value.trim()}')
        .toList();
    return instructionList;
  }

  List<String> _getWarnings() {
    // Retrieve allergy warnings from recipe data
    List<dynamic>? allergies = recipe['allergens'];
    if (allergies != null) {
      if (allergies is List<dynamic>) {
        return allergies
            .map((allergy) => allergy['name'].toString())
            .toList()
            .cast<String>();
      } else {
        // Return empty list if allergy data is not in expected format
        return [];
      }
    } else {
      // Return empty list if allergy data is missing
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> ingredients = recipe['extendedIngredients'];
    final String instructions = recipe['instructions'] ?? '';
    final List<String> warnings = _getWarnings();

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title']),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ingredients.map((ingredient) {
              return Text(
                '- ${ingredient['original']}',
                style: const TextStyle(fontSize: 16),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Instructions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _parseInstructions(instructions).map((instruction) {
              return Text(
                instruction.trim(),
                style: const TextStyle(fontSize: 16),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text(
            'Allergy Warnings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: warnings.map((warning) {
              return Text(
                '- $warning',
                style: const TextStyle(fontSize: 16),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}