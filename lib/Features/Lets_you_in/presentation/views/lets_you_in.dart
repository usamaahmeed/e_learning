import 'package:e_learning/Features/Lets_you_in/presentation/views/widgets/cirecle_avatar.dart';
import 'package:e_learning/Features/home/presentation/view/home_screen.dart';
import 'package:e_learning/Features/sign_up/presentation/views/sign_up.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../sign_in/presentation/views/sign_in.dart';

class ChoseScreen extends StatefulWidget {
  const ChoseScreen({super.key});

  @override
  State<ChoseScreen> createState() => _ChoseScreenState();
}

class _ChoseScreenState extends State<ChoseScreen> {
  @override
  void initState() {
    super.initState();
    print('My current user ${FirebaseAuth.instance.currentUser}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsData.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Let’s you in',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color(0xff202244)),
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () async {
                    await signInWithGoogle();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen();
                        },
                      ),
                    );
                  },
                  child: LoginWidget(
                    image: 'assets/images/Group 11.png',
                    textDate: 'Continue with Google',
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () async {
                    await signInWithFacebook();
                    //remove all screen and go to home screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen();
                        },
                      ),
                    );
                  },
                  child: LoginWidget(
                    image: 'assets/images/facebook.png',
                    textDate: 'Continue with Facebook',
                  ),
                ),
                const SizedBox(
                  height: 54,
                ),
                Text(
                  '( Or )',
                  style: TextStyle(
                    color: Color(0xff545454),
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return SignInScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Sign In with Your Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.sizeOf(context).width, 60),
                      backgroundColor: Color(0xff0961F5)),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don’t have an Account?',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Color(0xff545454),
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return const SignUpScreen();
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          color: Color(0xff0961F5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
      scopes: ['profile', 'email'],
    ).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //login with facebook
  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login(
      permissions: ['email', 'public_profile'],
    );

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }

  static Future<void> faceBookSignOut() async {
    await FacebookAuth.instance.logOut();
  }

  static Future<void> signOut() async {
    await GoogleSignIn().signOut();
  }

  //navigation to sign in page
}
