import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/home/presentation/view/home_screen.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  void initState() {
    super.initState();

    _fetchUserProfile();
    _nameController.text = user!.displayName ?? '';
  }

  Future<void> _fetchUserProfile() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      setState(() {
        phoneNumber = userDoc['phone'];
        gender = userDoc['gender'];
        stuts = userDoc['userType'];

        phone = '0' + phoneNumber!;
      });
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  String? phoneNumber;
  String? stuts;
  String? phone;
  String? displayName;
  String? photoURL;
  File? _image;
  String? gender;
  String? _imagePath;
  @override
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imagePath = pickedFile.path;
      });
    }
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
          backgroundColor: ColorsData.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_ios)),
                        Text(
                          'Edit Your Profile',
                          style: TextStyle(
                            color: Color(0XFF202244),
                            fontSize: 21,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 570,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xffe9f3ff),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: Color(0xff167F71),
                                child: CircleAvatar(
                                  radius: 58,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: _imagePath != null
                                      ? FileImage(File(_imagePath!))
                                      : user!.photoURL != null
                                          ? user!.photoURL!.contains('http')
                                              ? NetworkImage(user!.photoURL!)
                                              : FileImage(File(user!.photoURL!))
                                          : AssetImage(
                                              'assets/images/avatar.png'),
                                  child: _image == null
                                      ? Icon(Icons.camera_alt,
                                          color: Colors.grey[800], size: 50)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Full Name is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Full Name',
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
                                      width: 0.0,
                                      color: ColorsData.backgroundColor),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff0961F5)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 55,
                            padding: EdgeInsets.all(.5),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              height: 55,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.email_outlined),
                                  SizedBox(width: 10),
                                  Text(
                                    user!.email ??
                                        user!.providerData[0].email ??
                                        'Email',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 55,
                            padding: EdgeInsets.all(.5),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              height: 55,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.phone_android_outlined),
                                  SizedBox(width: 10),
                                  Text(
                                    phone ?? '01234567890',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 55,
                            padding: EdgeInsets.all(.5),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              height: 55,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.person_outline_outlined),
                                  SizedBox(width: 10),
                                  Text(
                                    gender ?? 'gender',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 55,
                            padding: EdgeInsets.all(.5),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              height: 55,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.book),
                                  SizedBox(width: 10),
                                  Text(
                                    stuts ?? 'status',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 38),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            User? user = FirebaseAuth.instance.currentUser;

                            await user?.updateProfile(
                              displayName: _nameController.text,
                              photoURL: _imagePath != null
                                  ? _imagePath
                                  : user!.photoURL,
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          } catch (e) {
                            // Handle profile update errors here
                            print('Failed to update profile: $e');
                          }
                        }
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 60),
                        backgroundColor: Color(0xff0961F5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
