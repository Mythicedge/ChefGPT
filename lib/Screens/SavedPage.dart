import 'package:flutter/material.dart';
import '../Data/recipe_model.dart';
import '../Data/recipemodel_provider.dart';
import 'package:provider/provider.dart'; 


class SavedPage extends StatefulWidget {
 
  //const SavedPage({Key? key, this.savedRecipes}) : super(key: key);
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

const double kSpacing = 20.0; 

class HeightSpacer extends StatelessWidget {
  final double height;

  const HeightSpacer({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class WidthSpacer extends StatelessWidget {
  final double width;

  const WidthSpacer({Key? key, required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class PrimaryBtn extends StatelessWidget {
  final Widget btnChild;
  final VoidCallback btnFun;

  const PrimaryBtn({Key? key, required this.btnChild, required this.btnFun}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: btnFun,
      child: btnChild,
    );
  }
}

class _SavedPageState extends State<SavedPage>{
  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipeProvider>(context).recipes;
    print("Building SavedPage with ${recipes.length} recipes.");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Recipes'),
      ),
      body: ListView.builder(
        itemCount: recipes.length, 
        itemBuilder: (context, index) {
          final recipe = recipes[index]; 
          return ListTile(
            title: Text(recipe.title),
            subtitle: Text(recipe.description),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                Provider.of<RecipeProvider>(context, listen: false).removeRecipe(index);
              },
            ),
          );
        },
      ),
    );
  }
}
