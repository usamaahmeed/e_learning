import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/Timeline/presentation/view/CourseDetailsPage.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__cubit.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__state.dart';
import 'package:e_learning/core/utils/courses_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookMark extends StatefulWidget {
  const BookMark({Key? key});

  @override
  State<BookMark> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMark> {
  @override
  void initState() {
    super.initState();
    context.read<TimelineCubit>().loadInitialData();
    initializeSoldState();
  }

  late List<String> soldCourseIds = [];

  Future<void> initializeSoldState() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(userId);
        DocumentSnapshot userSnapshot = await userDoc.get();

        if (userSnapshot.exists) {
          List<dynamic>? bookmarkedCourses = userSnapshot.get('soldCourses');

          setState(() {
            soldCourseIds = bookmarkedCourses!.cast<String>();
          });
        }
      }
    } catch (e) {
      print('Failed to initialize bookmark state: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelineCubit, TimelineState>(
      builder: (context, state) {
        if (state is TimelineError) {
          // Handle error state
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error occurred')),
          );
        }

        if (state is TimelineLoaded) {
          final courses = state.courses
              .where((element) => state.bookCourses.contains(element.courseId))
              .toList();

          final categories =
              ["All"] + courses.map((course) => course.title).toSet().toList();
          return courses.length == 0
              ? SizedBox(
                  child: Center(
                    child: Text('No Bookmarked Courses',
                        style: TextStyle(
                          color: Color(0xff202244),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 35,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: categories.map((category) {
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<TimelineCubit>()
                                    .filterCourses(category);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: state.selectedCategory == category
                                      ? Color(0xff167F71)
                                      : Color(0xffE8F1FF),
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color: state.selectedCategory == category
                                        ? Colors.white
                                        : Color(0xff202244),
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
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.bookFilteredCourses.length,
                        itemBuilder: (BuildContext context, int index) {
                          final course = state.bookFilteredCourses[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CourseDetailsPage(course: course),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 130,
                                    width: 130,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: CachedNetworkImageProvider(
                                              course.image),
                                        )),
                                  ),
                                  Container(
                                    height: 130,
                                    width: 220,
                                    padding: EdgeInsets.only(
                                      top: 15,
                                      left: 14,
                                      right: 20,
                                      bottom: 18,
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
                                            Expanded(child: SizedBox()),
                                            !soldCourseIds
                                                    .contains(course.courseId)
                                                ? BookMarkWidget(course: course)
                                                : SizedBox(),
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
                                        !soldCourseIds.contains(course.courseId)
                                            ? Text(
                                                '${course.price} E£',
                                                style: TextStyle(
                                                  color: Color(0xff0961F5),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              )
                                            : SizedBox(),
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
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 10);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
        }

        return Center(child: const CircularProgressIndicator());
      },
    );
  }
}

class BookMarkWidget extends StatefulWidget {
  final Course course;

  const BookMarkWidget({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  _BookMarkWidgetState createState() => _BookMarkWidgetState();
}

class _BookMarkWidgetState extends State<BookMarkWidget> {
  late bool isBookmarked = false; // Initialize with a default value

  @override
  void initState() {
    super.initState();
    _initializeBookmarkState();
  }

  Future<void> _initializeBookmarkState() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);
      DocumentSnapshot userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        List<dynamic> bookmarkedCourses = userSnapshot.get('bookmarkedCourses');
        setState(() {
          isBookmarked = bookmarkedCourses.contains(widget.course.courseId);
        });
      }
    }
  }

  Future<void> _updateFirestore(bool isBooked) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(userId);

        if (isBooked) {
          // Add the courseId to the user's bookmarked courses
          await userDoc.update({
            'bookmarkedCourses': FieldValue.arrayUnion([widget.course.courseId])
          });
        } else {
          // Remove the courseId from the user's bookmarked courses
          await userDoc.update({
            'bookmarkedCourses':
                FieldValue.arrayRemove([widget.course.courseId])
          });
        }

        setState(() {
          isBookmarked = isBooked;
        });
      }
    } catch (e) {
      print('Failed to update courses: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            var data = snapshot.data?.data() as Map<String, dynamic>?;
            if (data != null) {
              List<dynamic> bookmarkedCourses = data['bookmarkedCourses'] ?? [];
              isBookmarked = bookmarkedCourses.contains(widget.course.courseId);
            }
          } else if (snapshot.hasError) {
            print('Error fetching data: ${snapshot.error}');
          }
        }

        return GestureDetector(
          onTap: () async {
            if (!mounted) return;

            setState(() {
              isBookmarked = !isBookmarked;
            });

            await _updateFirestore(isBookmarked);

            // Remove course from list when unbookmarked
            if (!isBookmarked) {
              context.read<TimelineCubit>().removeCourse(widget.course);
              context
                  .read<TimelineCubit>()
                  .removeCourseTitle(widget.course.courseId);
            }
          },
          child: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Color(0xff167F71),
          ),
        );
      },
    );
  }
}
