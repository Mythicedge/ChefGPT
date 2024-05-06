import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipetestapp/components/my_buttons.dart';
import 'package:recipetestapp/components/my_textfield.dart';
import 'package:recipetestapp/components/square_tile.dart';
import 'RecipePage.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late bool _loading; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    _loading = false; // Initialize loading state to false
  }

  // sign user in method
  void signUserIn() async {
    setState(() {
      _loading = true; // Set loading state to true
    });

    try {
      // Perform sign-in operation
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // When login is successful, navigate to RecipePage
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RecipePage()),
      );

      // Check if the widget is still mounted before updating the UI
    } on FirebaseAuthException catch (e) {
      // Show error message based on error code
      _showErrorMessage(e.code);
    } finally {
      setState(() {
        _loading = false; // Set loading state to false
      });
    }
  }

  // Function to show error message in a dialog
  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // Transparent background
          content: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 173, 20, 9),
              borderRadius: BorderRadius.circular(10), // Rounded border radius
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Dismiss the dialog
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SquareTile(imagePath: 'lib/images/screenshot qqw.png'),
                // Welcome message
                Text(
                  'Welcome to Cooking App!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                // Username textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                // Password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                // Forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register Now',
                          style: TextStyle(color: Colors.blue[600]),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                // Sign in button
                _loading
                    ? CircularProgressIndicator() // Show loading indicator if loading
                    : MyButton(
                        text: 'Sign In',
                        onTap: signUserIn,
                      ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
