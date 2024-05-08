import 'dart:convert';

class Recipe {
  final String title;
  final List<String> ingredients;
  final String description;
  final String imageUrl;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ingredients': ingredients,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      title: map['title'],
      ingredients: List<String>.from(map['ingredients']),
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));
}
