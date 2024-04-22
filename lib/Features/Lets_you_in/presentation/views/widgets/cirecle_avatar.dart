import 'package:flutter/material.dart';

class LoginWidget extends StatelessWidget {
  final String image;
  final String textDate;

  const LoginWidget({
    super.key,
    required this.image,
    required this.textDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Image.asset(
            image,
            height: 24,
            width: 24,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Text(
          textDate,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xff545454)),
        )
      ],
    );
  }
}
