import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/home/presentation/view/home_screen.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:e_learning/core/utils/courses_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyDemoPage extends StatefulWidget {
  final Course course;
  const MyDemoPage({super.key, required this.course});

  @override
  State<MyDemoPage> createState() => _MyDemoPageState();
}

class _MyDemoPageState extends State<MyDemoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        _showDialog(context);

        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          String userId = user.uid;
          DocumentReference userDoc =
              FirebaseFirestore.instance.collection('users').doc(userId);
          await userDoc.update({
            'soldCourses': FieldValue.arrayUnion([widget.course.courseId])
          });
          await userDoc.update({
            'bookmarkedCourses':
                FieldValue.arrayRemove([widget.course.courseId])
          });

          _hideLoadingDialog();

          // Navigate to the home screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false,
          );
        }
      } catch (e) {
        _hideLoadingDialog();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to update profile: $e'),
          ),
        );
      }
    }
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffF5F9FF),
          title: const Text(
            'Congratulations',
            style: TextStyle(
                color: Color(0xff202244),
                fontWeight: FontWeight.w600,
                fontSize: 24),
          ),
          content: Container(
            height: 150,
            child: Column(
              children: [
                SingleChildScrollView(
                  child: const Text(
                    'Your Payment is Successfully. Purchase a New Course',
                    style: TextStyle(
                        color: Color(0xff545454),
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffF5F9FF),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Congratulations"),
            ],
          ),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Color(0xffF5F9FF),
          appBar: AppBar(
            backgroundColor: Color(0xffF5F9FF),
            title: Text('Payment'),
            //action of icon back  Navigator.of(context).pushReplacement
            elevation: 0.0,
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Column(
                  children: [
                    Image.asset('assets/images/CARD.png'),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Card Name',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Card Name',
                        hintStyle: TextStyle(
                          color: Color(0xff505050),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.0, color: ColorsData.backgroundColor),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0961F5)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.length < 16) {
                          return 'Card Number should be at least 16 characters';
                        }
                        return null;
                      },
                      inputFormatters: [LengthLimitingTextInputFormatter(16)],
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Card Number',
                        hintStyle: TextStyle(
                          color: Color(0xff505050),
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.0, color: ColorsData.backgroundColor),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff0961F5)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ElevatedButton(
                        onPressed: _updateUserProfile,
                        child: Text(
                          'Enroll Course ${widget.course.price} E£',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff0961F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 60)),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
