import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/core/utils/courses_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookMarkWidget extends StatefulWidget {
  final Course course;

  const BookMarkWidget({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  _BookMarkWidgetState createState() => _BookMarkWidgetState();
}

class _BookMarkWidgetState extends State<BookMarkWidget> {
  late bool isBookmarked = false; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    _initializeBookmarkState();
  }

  Future<void> _initializeBookmarkState() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        List<dynamic> bookmarkedCourses = userSnapshot.get('bookmarkedCourses');
        setState(() {
          isBookmarked = bookmarkedCourses.contains(widget.course.courseId);
        });
      }
    }
  }

  Future<void> _updateFirestore(bool isBooked) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(userId);

        if (isBooked) {
          // Add the courseId to the user's bookmarked courses
          await userDoc.update({
            'bookmarkedCourses': FieldValue.arrayUnion([widget.course.courseId])
          });
        } else {
          // Remove the courseId from the user's bookmarked courses
          await userDoc.update({
            'bookmarkedCourses':
                FieldValue.arrayRemove([widget.course.courseId])
          });
        }

        setState(() {
          isBookmarked = isBooked;
        });
      }
    } catch (e) {
      print('Failed to update courses: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            var data = snapshot.data?.data() as Map<String, dynamic>?;
            if (data != null) {
              List<dynamic> bookmarkedCourses = data['bookmarkedCourses'] ?? [];
              isBookmarked = bookmarkedCourses.contains(widget.course.courseId);
            }
          } else if (snapshot.hasError) {
            print('Error fetching data: ${snapshot.error}');
          }
        }

        return GestureDetector(
          onTap: () async {
            if (!mounted) return;

            setState(() {
              isBookmarked = !isBookmarked;
            });

            await _updateFirestore(isBookmarked);
          },
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Color(0xff167F71),
          ),
        );
      },
    );
  }
}
