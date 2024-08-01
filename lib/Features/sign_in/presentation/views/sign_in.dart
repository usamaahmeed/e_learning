import 'package:e_learning/Features/Lets_you_in/presentation/views/lets_you_in.dart';
import 'package:e_learning/Features/home/presentation/view/home_screen.dart';
import 'package:e_learning/Features/sign_up/presentation/views/sign_up.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  bool valuefirst = false;
  bool _checkbox = false;

  void initState() {
    super.initState();
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
              Text("Signing in..."),
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
      key: formKey,
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
                    const SizedBox(
                      height: 70,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/logo1.png',
                        width: 185,
                        height: 70,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                      'Let’s Sign In.!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff202244),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Login to Your Account to Continue your Courses',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff545454),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'[#$*/(\-)<>%^&:;+_!?؟=\"\s]')),
                      ],
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Email should be at least 6 characters';
                        }
                        if (!(value.contains('@edu') &&
                            value.contains('\.com') &&
                            value.length > 6)) {
                          return 'Email should  contain @edu.com';
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
                      obscureText: isObscure,
                      controller: passwordController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.length < 8) {
                          return 'Password should be at least 8 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          child: isObscure
                              ? Icon(
                                  Icons.visibility_off,
                                  size: 25,
                                  color: Color(0xff545454),
                                )
                              : Icon(
                                  Icons.visibility,
                                  size: 25,
                                  color: Color(0xff545454),
                                ),
                        ),
                        hintText: 'Passward',
                        hintStyle: TextStyle(
                          color: Color(0xff505050),
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
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
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(),
                        ),
                        const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xff545454),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          _showLoadingDialog();
                          try {
                            await _auth.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            _hideLoadingDialog();

                            // Navigate to home screen after successful sign in
                            navigateToHome(context);
                          } catch (e) {
                            _hideLoadingDialog();
                            // Show error message if sign in fails
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Failed to sign in'),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Sign In',
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
                      height: 25,
                    ),
                    Center(
                      child: Text(
                        'Or ',
                        style: TextStyle(
                          color: Color(0xff545454),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChoseScreen();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'login with Google or Facebook',
                            style: TextStyle(
                              color: Color(0xff0961F5),
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
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
                            // Navigate to sign up screen
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return SignUpScreen();
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
                      height: 30,
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

  navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return HomeScreen();
        },
      ),
    );
  }
}
