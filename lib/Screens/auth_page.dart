import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:food_app/screens/home_page.dart';
//import 'package:food_app/pages/login_or_register_page.dart';
import 'home_page.dart';
import 'login_or_register_page.dart';

class AuthPage extends StatelessWidget{
  const AuthPage({super.key});

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          //logged in
          if (snapshot.hasData){
            return HomePage();
          }

          //not logged in 
          else{
            return LoginOrRegisterPage();
          }
        }),
      ),
    );
  }
}