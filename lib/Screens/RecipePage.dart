import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../Data/homepage_repo.dart';
import 'SavedPage.dart';
import 'ProfilePage.dart';


class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

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

class _HomePageState extends State<RecipePage> {
  late TextEditingController controller;
  late FocusNode focusNode;
  final List<String> inputTags = [];
  String response = '';
  String imageUrl = '';

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecipePage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SavedPage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
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
                'Find the best recipe for cooking!',
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
                        controller.clear();
                        setState(() {
                          inputTags.add(value);
                          focusNode.requestFocus();
                        });
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
                    color: Theme.of(context).colorScheme.primary,
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: IconButton(
                        onPressed: () {
                          controller.clear();
                          setState(() {
                            inputTags.add(controller.text);
                            focusNode.requestFocus();
                          });
                          print(inputTags);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
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
                    children: [
                      if (imageUrl.isNotEmpty)
                        Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                          width: 200,
                        ),
                      Text(
                        response,
                        style: TextStyle(fontSize: 20),
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
      bottomNavigationBar: BottomNavigationBar(
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
