import 'package:e_learning/Features/home/presentation/view/home_screen.dart';
import 'package:e_learning/Features/sign_up/presentation/views/sign_up.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:flutter/material.dart';

class FillProfile extends StatefulWidget {
  final String email;
  const FillProfile({super.key, required this.email});

  @override
  State<FillProfile> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<FillProfile> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUpScreen();
                              },
                            ),
                          );
                        },
                        color: Color(0XFF202244),
                        icon: Icon(Icons.arrow_back_outlined),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Fill Your Profile',
                        style: TextStyle(
                          color: Color(0XFF202244),
                          fontSize: 21,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
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
                      //add email to textformfield

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
                    height: 38,
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
                ],
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
