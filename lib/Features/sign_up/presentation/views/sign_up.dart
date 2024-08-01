import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/Lets_you_in/presentation/views/lets_you_in.dart';
import 'package:e_learning/Features/fill_profile/presentation/views/fill_profile.dart';
import 'package:e_learning/Features/sign_in/presentation/views/sign_in.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:e_learning/core/utils/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xffF5F9FF),
          title: const Text('Terms & Conditions'),
          content: SingleChildScrollView(
            child: const Text(
                'Welcome to our e-learning platform! Please read these Terms and Conditions carefully before using our services.\n1. User AccountsRegistration: You must create an account to access certain features. Provide accurate information and keep your login details secure.Account Security: You are responsible for all activities under your account.\n2. Courses and ContentCourse Access: When you enroll in a course, you can use the materials for personal and educational purposes only.Content Ownership: All content on our platform belongs to us or our content providers.\n3. Payments and RefundsPricing: Course prices are listed on our platform and may change.Payments: Payments are processed securely through our payment partners.Refunds: Refunds are handled on a case-by-case basis. Check our Refund Policy for details.\n4. User ConductProhibited Activities: Do not share your account, copy content, use automated systems, or engage in harmful activities.\n5. PrivacyPrivacy Policy: We care about your privacy. Please read our Privacy Policy to understand how we handle your personal information.\n6. Limitation of LiabilityWe are not responsible for indirect damages, loss of data, or any harm resulting from your use of our services.\n7. Changes to TermsWe may update these terms at any time. Continued use of our services means you accept the new terms.\n8. TerminationWe can suspend or terminate your account if you violate these terms.'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _checkbox = true;
                });
                Navigator.of(context).pop();
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
                      'Getting Started.!',
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
                      'Create an Account to Continue your allCourses',
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
                            RegExp(r'[@.#$*/(\-)+<>%^&:_;!?؟=\"\s]')),
                      ],
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (!(value!.length > 6)) {
                          return 'Email should be 6 characters long ';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.mail_outline_outlined),
                        suffix: Text('@edu.com'),
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
                        Checkbox(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          side: BorderSide(width: 2, color: Color(0xff167F71)),
                          checkColor: Colors.white,
                          activeColor: Color(0xff167F71),
                          value: _checkbox,
                          onChanged: (value) {
                            _checkbox == true
                                ? setState(() {
                                    _checkbox = false;
                                  })
                                : _showDialog(context);
                          },
                        ),
                        const Text(
                          'Agree to Terms & Conditions',
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
                        if (!formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('Please fill in the text'),
                            ),
                          );
                        }
                        if (!_checkbox && formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                  'Please agree to the Terms & Conditions'),
                            ),
                          );
                          return;
                        }

                        if (formKey.currentState!.validate()) {
                          String email = emailController.text + '@edu\.com';
                          print(email);
                          _showLoadingDialog();
                          try {
                            final signInMethods = await FirebaseFirestore
                                .instance
                                .collection('users')
                                .get();
                            List<UserModel> listOfUsers = [];
                            for (final userDoc in signInMethods.docs) {
                              final data = userDoc.data();
                              final modelUser = UserModel.fromJson(data);
                              listOfUsers.add(modelUser);
                              print(listOfUsers);
                            }

                            if (listOfUsers
                                .any((element) => element.email == email)) {
                              _hideLoadingDialog();

                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      'The email address is already in use (Sign in)'),
                                ),
                              );
                              emailController.text = '';
                              passwordController.text = '';
                              setState(() {
                                _checkbox = false;
                              });
                            } else {
                              _hideLoadingDialog();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FillProfile(
                                      email: email,
                                      password: passwordController.text,
                                    );
                                  },
                                ),
                              );
                            }
                          } catch (error) {
                            _hideLoadingDialog();
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                    'The email address is already in use (Sign in)'),
                              ),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.sizeOf(context).width, 60),
                        backgroundColor: Color(0xff0961F5),
                      ),
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
                          'Have an Account?',
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
                                  return SignInScreen();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'SIGN IN',
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
}
