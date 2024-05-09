import 'dart:convert';

class Recipe {
  final String id; 
  final String title;
  final List<String> ingredients;
  final String description;
  final String imageUrl;

  Recipe({
    this.id = '', 
    required this.title,
    required this.ingredients,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'title': title,
      'ingredients': ingredients,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '', 
      title: map['title'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Recipe.fromJson(String source) => Recipe.fromMap(json.decode(source));
}
