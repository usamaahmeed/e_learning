import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/home/presentation/view/home_screen.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class FillProfile extends StatefulWidget {
  final String email;
  final String password;
  const FillProfile({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  State<FillProfile> createState() => _FillProfileState();
}

class _FillProfileState extends State<FillProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _image;
  String? gender;
  String? _userType;
  DateTime? _selectedDate;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${_auth.currentUser!.uid}.jpg');
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

        // Create the user
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: widget.email,
          password: widget.password,
        );
        User? user = userCredential.user;

        if (user != null) {
          String? imageUrl;
          if (_image != null) {
            imageUrl = await _uploadImage(_image!);
          }

          // Update display name and photoURL in FirebaseAuth
          await user.updateProfile(
            displayName: _nameController.text,
            photoURL: imageUrl,
          );

          List<String> bookmarkedCourses = [];

          // Save additional user information to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': _nameController.text,
            'email': user.email,
            'phone': _phoneController.text,
            'gender': gender,
            'photoURL': imageUrl,
            'userType': _userType,
            'birthdate': _selectedDate,
            'bookmarkedCourses': bookmarkedCourses,
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
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
              Text("Signing up..."),
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
              'Fill Your Profile',
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 670,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xffe9f3ff),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 5,
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
                                  backgroundImage: _image != null
                                      ? FileImage(_image!)
                                      : AssetImage('assets/images/avatar.png')
                                          as ImageProvider,
                                  child: _image == null
                                      ? Icon(Icons.camera_alt,
                                          color: Colors.grey[800], size: 50)
                                      : null,
                                ),
                              ),
                            ),
                          ),
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
                          TextFormField(
                            initialValue: widget.email,
                            readOnly: true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (!(value!.contains('@') &&
                                  value.contains('.') &&
                                  value.length > 8)) {
                                return 'Email is not valid';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.mail_outline_outlined),
                              hintText: 'Email',
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
                          IntlPhoneField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,

                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Phone Number',
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
                                  color: ColorsData.backgroundColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff0961F5)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            initialCountryCode: 'EG', // Egypt
                            onChanged: (phone) {
                              print(phone.completeNumber);
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10)
                            ],
                            disableLengthCheck: true,
                          ),
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            value: gender,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Select Gender',
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
                                  color: ColorsData.backgroundColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff0961F5)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'male',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'female',
                                child: Text('Female'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                gender = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Gender is required';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            validator: (value) {
                              if (_selectedDate == null) {
                                return 'Date of Birth is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: _selectedDate == null
                                  ? 'Date of Birth'
                                  : 'Date of Birth: ${DateFormat.yMMMd().format(_selectedDate!)}',
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
                          DropdownButtonFormField<String>(
                            dropdownColor: Colors.white,
                            value: _userType,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Select User Type',
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
                                  color: ColorsData.backgroundColor,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff0961F5)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'student',
                                child: Text('Student'),
                              ),
                              DropdownMenuItem(
                                value: 'mentor',
                                child: Text('Mentor'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _userType = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'User Type is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 38),
                    ElevatedButton(
                      onPressed: _updateUserProfile,
                      child: Text(
                        'Sign Up',
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

  void navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      ),
    );
  }
}
