 import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipetestapp/components/my_buttons.dart';
import 'package:recipetestapp/components/my_textfield.dart';
import 'package:recipetestapp/components/square_tile.dart';
import 'login_page.dart'; // Import the login page

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late bool _loading; // Variable to track loading state

  @override
  void initState() {
    super.initState();
    _loading = false; // Initialize loading state to false
  }

  // sign user up
  void signUserUp() async {
    setState(() {
      _loading = true; // Set loading state to true
    });

    try {
      // Check if the password is the same
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        //show error message, passwords don't match
        _showErrorMessage("Passwords don't match");
      }
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
                SquareTile(imagePath: 'lib/images/Screenshot 2024-04-23 at 8.09.02 AM.png'),
                // Welcome message
                Text(
                  'Create an Account',
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
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                // Forgot password?
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(
                                onTap: () {
                                  Navigator.pop(context); // Navigate back to register page if needed
                                },
                              ),
                            ),
                          );
                        },
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
                        text: 'Sign Up',
                        onTap: signUserUp,
                      ),
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(
                                onTap: () {
                                  Navigator.pop(context); // Navigate back to register page if needed
                                },
                              ),
                            ),
                          );
                        },
                        child: Text(
                          ' Login Now',
                          style: TextStyle(color: Colors.blue[600]),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}