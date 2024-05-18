import 'dart:io';

import 'package:e_learning/Features/Lets_you_in/presentation/views/lets_you_in.dart';
import 'package:e_learning/Features/Profile/presentation/view/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                if (FirebaseAuth.instance.currentUser != null) {
                  FirebaseAuth.instance.signOut();
                  FacebookAuth.instance.logOut();
                  GoogleSignIn().signOut();
                }
                Navigator.of(context).pop();
                //go to chose screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChoseScreen(),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 800,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Color(0xff167F71),
                        child: CircleAvatar(
                          // backgroundColor: Color(0xffd8d8d8),
                          backgroundImage: user!.photoURL != null
                              ? user!.photoURL!.contains('http')
                                  ? NetworkImage(user!.photoURL!)
                                  : FileImage(File(user!.photoURL!))
                              : AssetImage('assets/images/avatar.png'),
                          radius: 57,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        user!.displayName ?? 'Name',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff202244)),
                      ),
                      Text(
                        user!.email ?? user!.providerData[0].email ?? 'Email',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff202244)),
                      ),
                      SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return EditProfile();
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.person),
                                SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Edit Profile',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff202244)),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(CupertinoIcons.bookmark),
                                SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Book Mark',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff202244)),
                                ),
                                SizedBox(width: 84),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.notifications_none),
                                SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Notification',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff202244)),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.security_outlined),
                                SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Security',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff202244)),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.payment_rounded),
                                SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'payment Option',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff202244)),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios_outlined)
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.shield_outlined),
                                SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'TermsConditions',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff202244)),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios_outlined),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {
                          _showDialog(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.logout_outlined),
                                SizedBox(
                                  width: 13,
                                ),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff202244)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
