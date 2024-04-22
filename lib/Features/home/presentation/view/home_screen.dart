import 'package:e_learning/Features/sign_in/presentation/views/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TextButton(
          onPressed: () {
            if (FirebaseAuth.instance.currentUser != null) {
              FirebaseAuth.instance.signOut();
              FacebookAuth.instance.logOut();
              GoogleSignIn().signOut();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) {
                    return SignInScreen();
                  },
                ),
              );
            }
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
