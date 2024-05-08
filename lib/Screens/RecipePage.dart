import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../Data/homepage_repo.dart';
import '../Data/recipe_model.dart';

class RecipePage extends StatefulWidget {
  final List<Recipe> savedRecipes;
  final void Function()? onRecipeSaved;

  //const RecipePage({Key? key, required this.savedRecipes}) : super(key: key);
    const RecipePage({Key? key, required this.savedRecipes, this.onRecipeSaved}) : super(key: key);

  @override
  State<RecipePage> createState() => _HomePageState();
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

class _HomePageState extends State<RecipePage>{
  late TextEditingController controller;
  late FocusNode focusNode;
  final List<String> inputTags = [];
  String response = '';
  String imageUrl = '';

  //print("Saving recipe: ${recipe.imageUrl}");  // Check what's being saved


  void saveRecipe(Recipe recipe) {
    setState(() {
      widget.savedRecipes.add(recipe);
    });
    widget.onRecipeSaved?.call();  // Call the callback after updating the list
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Recipe saved!"),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                'Generate a recipe!',
                maxLines: 3,
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      autofocus: true,
                      autocorrect: true,
                      focusNode: focusNode,
                      controller: controller,
                      onFieldSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            inputTags.add(value);
                            controller.clear();
                            focusNode.requestFocus();
                          });
                        }
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.5),
                            bottomLeft: Radius.circular(5.5),
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: "Enter the ingredients you have...",
                        labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 63, 
                    width: 63,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.5),
                        bottomRight: Radius.circular(5.5),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          setState(() {
                            inputTags.add(controller.text);
                            controller.clear();
                            focusNode.requestFocus();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Wrap(
                  children: [
                    for (int i = 0; i < inputTags.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Chip(
                          backgroundColor: Color(
                            (math.Random().nextDouble() * 0xFFFFFF).toInt(),
                          ).withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.5),
                          ),
                          onDeleted: () {
                            setState(() {
                              inputTags.remove(inputTags[i]);
                            });
                          },
                          label: Text(inputTags[i]),
                          deleteIcon: const Icon(
                            Icons.close,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      if (response.isNotEmpty && imageUrl.isNotEmpty)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(imageUrl, width: 200, height: 200, fit: BoxFit.cover),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(Icons.bookmark, size: 30),
                                  onPressed: () => saveRecipe(
                                    Recipe(
                                      title: "Generated Recipe", 
                                      ingredients: inputTags,
                                      description: response,
                                      imageUrl: imageUrl,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(response, style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              HeightSpacer(height: kSpacing / 2),
              Align(
                alignment: Alignment.bottomCenter,
                child: PrimaryBtn(
                  btnChild: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.auto_awesome),
                      WidthSpacer(width: kSpacing / 2),
                      const Text('Create Recipe'),
                    ],
                  ),
                  btnFun: () async {
              setState(() => response = "Generating recipe...");

              try {
                var recipeText = await HomePageRepo().askAI(inputTags.join(", "));
                if (recipeText != null && recipeText.isNotEmpty) {
                  setState(() => response = recipeText);

                  var imageUrl = await HomePageRepo().generateImage(recipeText);
                  if (imageUrl is String && imageUrl.startsWith("http")) {
                    setState(() {
                      this.imageUrl = imageUrl; // Assign URL to imageUrl
                      response = recipeText; // Display recipe text
                    });
                  } else {
                    setState(() => response = "Failed to process image: $imageUrl");
                  }
                } else {
                  setState(() => response = "Failed to generate recipe.");
                }
              } catch (e) {
                setState(() => response = "Error generating recipe: ${e.toString()}");
              }
            },

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}