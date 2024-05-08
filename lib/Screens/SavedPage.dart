import 'package:flutter/material.dart';
import '../Data/recipe_model.dart';

class SavedPage extends StatefulWidget {
  final List<Recipe>? savedRecipes;

  const SavedPage({Key? key, this.savedRecipes}) : super(key: key);

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
    print("Building SavedPage with ${widget.savedRecipes?.length} recipes.");
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Recipes'),
      ),
      body: ListView.builder(
        itemCount: widget.savedRecipes?.length ?? 0, 
        itemBuilder: (context, index) {
          final recipe = widget.savedRecipes?[index]; 
          if (recipe != null) {
            return ListTile(
              title: Text(recipe.title),
              subtitle: Text(recipe.description),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  if (widget.savedRecipes != null) {
                    setState(() {
                      widget.savedRecipes!.removeAt(index);
                    });
                  }
                },
              ),
            );
          } else {
            return Container(); 
          }
        },
      ),
    );
  }
}
