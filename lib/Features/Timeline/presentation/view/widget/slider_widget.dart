import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_learning/core/utils/data.dart';
import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  late List<String> shuffledImages;

  @override
  void initState() {
    super.initState();
    // Shuffling images only once
    shuffledImages = List<String>.from(images2)..shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 206.0,
          autoPlay: true,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 6),
          autoPlayCurve: Curves.slowMiddle,
        ),
        items: shuffledImages.map(
          (i) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 8),
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
