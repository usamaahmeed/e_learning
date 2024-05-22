import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_learning/core/utils/data.dart';
import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    final shuffledImages = List<String>.from(images2)..shuffle(Random());
    return Container(
      width: width,
      child: CarouselSlider(
        options: CarouselOptions(
            height: 206.0,
            autoPlay: true,
            viewportFraction: 1,
            autoPlayInterval: const Duration(
              seconds: 12,
            ),
            autoPlayCurve: Curves.slowMiddle),
        items: shuffledImages.map(
          (i) {
            return Builder(
              builder: (
                BuildContext context,
              ) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: AssetImage(i),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
