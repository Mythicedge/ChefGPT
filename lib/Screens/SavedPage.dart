import 'package:flutter/material.dart';
import '../Data/recipemodel_provider.dart';
import 'package:provider/provider.dart'; 


class SavedPage extends StatefulWidget {
 
  //const SavedPage({Key? key, this.savedRecipes}) : super(key: key);
  const SavedPage({Key? key}) : super(key: key);

  @override
  State<SavedPage> createState() => _SavedPageState();
}

const double kSpacing = 20.0; 

class HeightSpacer extends StatelessWidget { //Used to help with Styling
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

class _SavedPageState extends State<SavedPage> {

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipeProvider>(context).recipes; // Provider is used to automatically update the Page in real time 
    print("Building SavedPage with ${recipes.length} recipes.");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Recipes'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Card(
            child: ExpansionTile( // ExpansionTile used to display each Saved Recipes. Upon pressing one of these recipe banners, it will expand
              title: Text(recipe.title),
              leading: Image.network(
                recipe.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                 // a
                  return Image.asset(
                    'lib/images/blank.png',  // Placeholder Image, Avoid Image Exception Errors
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  );
                },
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.description, style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("Ingredients: " + recipe.ingredients.join(', ')),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          IconButton( // Delete Saved Recipes Button
                            icon: Icon(Icons.delete), 
                            onPressed: () {
                              String recipeId = recipes[index].id;
                              Provider.of<RecipeProvider>(context, listen: false).removeRecipe(recipeId);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Recipe deleted"),
                                duration: Duration(seconds: 2),
                              ));
                            },
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}


