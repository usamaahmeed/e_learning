import 'package:flutter/material.dart';

class CircleAvatarWidget extends StatelessWidget {
  final String image;

  const CircleAvatarWidget({
    super.key,
    required this.image,
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
      ],
    );
  }
}
