import 'dart:io';

import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__cubit.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__state.dart';
import 'package:e_learning/Features/Timeline/presentation/view/widget/slider_widget.dart';
import 'package:e_learning/Features/home/presentation/view/search.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:e_learning/core/utils/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimelineCubit()..loadInitialData(),
      child: TimelineView(),
    );
  }
}

class TimelineView extends StatelessWidget {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final width = MediaQuery.of(context).size.width;
    final categories =
        ["All"] + coursesList.map((course) => course.title).toSet().toList();
    final categories1 =
        coursesList.map((course) => course.title).toSet().toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi ${user!.displayName}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff202244),
                      ),
                    ),
                    Container(
                      width: 244,
                      child: Text(
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        'What Would you like to learn Today? Search Below.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff545454),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: user.photoURL != null
                      ? user.photoURL!.contains('http')
                          ? NetworkImage(user.photoURL!)
                          : FileImage(File(user.photoURL!)) as ImageProvider
                      : AssetImage('assets/images/avatar.png'),
                ),
              ],
            ),
            const SizedBox(height: 44),
            TextFormField(
              readOnly: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search_outlined),
                hintText: 'Search for...',
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            SliderWidget(width: width),
            const SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff202244),
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0961F5),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Color(0xff0961F5),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 35,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories1.take(4).map((category) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilteredCoursesScreen(
                              category: category,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffE8F1FF),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: Color(0xff0961F5),
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Popular Courses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff202244),
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0961F5),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Color(0xff0961F5),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 35,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    return GestureDetector(
                      onTap: () {
                        context.read<TimelineCubit>().filterCourses(category);
                      },
                      child: BlocBuilder<TimelineCubit, TimelineState>(
                        builder: (context, state) {
                          if (state is TimelineLoaded) {
                            return Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: state.selectedCategory == category
                                    ? Color(0xff0961F5)
                                    : Color(0xffE8F1FF),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: state.selectedCategory == category
                                      ? Colors.white
                                      : Color(0xff0961F5),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<TimelineCubit, TimelineState>(
              builder: (context, state) {
                if (state is TimelineLoaded) {
                  return SizedBox(
                    height: 240,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.filteredCourses.map((course) {
                          return Container(
                            height: 240,
                            width: 280,
                            margin: EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffE8F1FF),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 2,
                                  blurRadius: 1,
                                  offset: Offset(1, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 134,
                                  width: 280,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(course.image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 106,
                                  width: 280,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                  ),
                                  padding: EdgeInsets.only(
                                    top: 10,
                                    left: 14,
                                    right: 19,
                                    bottom: 21,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            course.title,
                                            style: TextStyle(
                                              color: Color(0xffFF6B00),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Expanded(
                                            child: SizedBox(),
                                          ),
                                          Icon(
                                            Icons.bookmark_border_outlined,
                                            color: Color(0xff167F71),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 200,
                                        child: Text(
                                          course.name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Color(0xff202244),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 120,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${course.price} E£',
                                              style: TextStyle(
                                                color: Color(0xff0961F5),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            Text(
                                              '|',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Color(0xffFAC025),
                                                ),
                                                Text(
                                                  course.rate.toString(),
                                                  style: TextStyle(
                                                    color: Color(0xff202244),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Top Mentor',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff202244),
                  ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff0961F5),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Color(0xff0961F5),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 96,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Builder(
                      builder: (context) {
                        final Set<String> displayedMentors = {};
                        final List<Widget> mentorWidgets = [];

                        for (var course in coursesList) {
                          if (!displayedMentors.contains(course.instructor)) {
                            displayedMentors.add(course.instructor);
                            mentorWidgets.add(
                              Container(
                                padding: EdgeInsets.only(right: 18),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              course.instructorImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      child: Text(
                                        overflow: TextOverflow.ellipsis,
                                        course.instructor,
                                        style: TextStyle(
                                          color: Color(0xff202244),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        }

                        return Row(children: mentorWidgets);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class FilteredCoursesScreen extends StatelessWidget {
  final String category;

  const FilteredCoursesScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    final filteredCourses =
        coursesList.where((course) => course.title == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: ListView.builder(
        itemCount: filteredCourses.length,
        itemBuilder: (BuildContext context, int index) {
          final course = filteredCourses[index];
          return ListTile(
            title: Text(course.name),
            subtitle: Text(course.title),
            onTap: () {
              // Navigate to course details page or perform any action
            },
          );
        },
      ),
    );
  }
}
