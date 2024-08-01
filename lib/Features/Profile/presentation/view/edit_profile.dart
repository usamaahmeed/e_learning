import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/home/presentation/view/home_screen.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
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

        phone!.length != 1 ? phone = '0' + phoneNumber! : phone = '01234567890';
      });
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

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

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user!.uid}.jpg');
      await storageRef.putFile(image);
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        _showLoadingDialog();
        String? imageUrl;
        if (_image != null) {
          imageUrl = await _uploadImage(_image!);
        }

        if (user != null) {
          // Update Firebase Authentication profile
          await user!.updateProfile(
            displayName: _nameController.text,
            photoURL: imageUrl ?? user!.photoURL,
          );

          // Update Firestore with new user data
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .set({
            'name': _nameController.text,
            'photoURL': imageUrl ?? user!.photoURL,
          }, SetOptions(merge: true)); // merge: true to update existing data

          _hideLoadingDialog();

          // Navigate to HomeScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      } catch (e) {
        // Handle profile update errors here
        print('Failed to update profile: $e');
      }
    }
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
              Text("Updating..."),
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
          backgroundColor: ColorsData.backgroundColor,
          appBar: AppBar(
            backgroundColor: Color(0xFFF5F9FF),
            title: Text(
              'Edit Your Profile',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: Color(0xff202244),
              ),
            ),
            elevation: 0,
            surfaceTintColor: Color(0xFFF5F9FF),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      onPressed: _updateUserProfile,
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
