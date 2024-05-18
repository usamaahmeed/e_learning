import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/home/presentation/view/home_screen.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class FillProfile extends StatefulWidget {
  const FillProfile({Key? key}) : super(key: key);

  @override
  State<FillProfile> createState() => _FillProfileState();
}

class _FillProfileState extends State<FillProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
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

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (user != null) {
          // Update display name and photoURL in FirebaseAuth
          await user?.updateProfile(
            displayName: _nameController.text,
            photoURL: _image?.path,
          );

          // Save phone number and gender to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .set({
            'name': _nameController.text,
            'email': user!.email,
            'phone': _phoneController.text,
            'gender': gender,
            'photoURL': _image?.path,
            'userType': _userType,
            'birthdate': _selectedDate,
          });

          // Navigate to the home screen if the profile update is successful
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
                    SizedBox(height: 15),
                    Text(
                      'Fill Your Profile',
                      style: TextStyle(
                        color: Color(0XFF202244),
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 670,
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
                          SizedBox(height: 20),
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
                          TextFormField(
                            initialValue: user!.email,
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
                          SizedBox(height: 20),
                          IntlPhoneField(
                            controller: _phoneController,
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
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
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
                          SizedBox(height: 20),
                          TextFormField(
                            readOnly: true,
                            onTap: () => _selectDate(context),
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
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
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
                        'Sign In',
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
