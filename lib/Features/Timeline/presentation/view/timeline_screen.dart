import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    print('My current user ${FirebaseAuth.instance.currentUser}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${user!.displayName}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff202244),
                  ),
                ),
                Container(
                  width: 244,
                  child: Text(
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    'What Would you like to learn Today? Search Below.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff545454),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: SizedBox()),
            CircleAvatar(
              radius: 25,
              backgroundImage: user!.photoURL != null
                  ? user!.photoURL!.contains('http')
                      ? NetworkImage(user!.photoURL!)
                      : FileImage(File(user!.photoURL!))
                  : AssetImage('assets/images/avatar.png'),
            ),
          ],
        ),
      ],
    );
  }
}
