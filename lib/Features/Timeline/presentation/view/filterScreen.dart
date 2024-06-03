import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/Features/Timeline/presentation/view/CourseDetailsPage.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__cubit.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__state.dart';
import 'package:e_learning/Features/Timeline/presentation/view/widget/book_widget.dart';
import 'package:e_learning/core/utils/courses_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilteredCoursesScreen extends StatefulWidget {
  final String category;

  const FilteredCoursesScreen({required this.category});

  @override
  _FilteredCoursesScreenState createState() => _FilteredCoursesScreenState();
}

class _FilteredCoursesScreenState extends State<FilteredCoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color coursesColor = Color(0xff167F71);
  Color instructorsColor = Color(0xffE8F1FF);
  Color coursesTextColor = Colors.white;
  Color instructorsTextColor = Color(0xff202244);

  @override
  void initState() {
    super.initState();
    context.read<TimelineCubit>().loadInitialData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      if (_tabController.index == 0) {
        coursesColor = Color(0xff167F71);
        instructorsColor = Color(0xffE8F1FF);
        coursesTextColor = Colors.white;
        instructorsTextColor = Color(0xff202244);
      } else {
        coursesColor = Color(0xffE8F1FF);
        instructorsColor = Color(0xff167F71);
        coursesTextColor = Color(0xff202244);
        instructorsTextColor = Colors.white;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: Color(0xFFF5F9FF),
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F9FF),
          title: Text(
            widget.category,
            style: TextStyle(
              color: Color(0xff202244),
              fontSize: 21,
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
            indicator: BoxDecoration(),
            dividerColor: Color(0xFFF5F9FF),
            controller: _tabController,
            tabs: [
              Tab(
                child: Container(
                  constraints: BoxConstraints.expand(), // Full width
                  padding: EdgeInsets.all(8),
                  // margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: coursesColor,
                  ),
                  child: Center(
                    // Center the text inside the container
                    child: Text(
                      'Courses',
                      style: TextStyle(
                        color: coursesTextColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  constraints: BoxConstraints.expand(), // Full width
                  padding: EdgeInsets.all(8),
                  // margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: instructorsColor,
                  ),
                  child: Center(
                    // Center the text inside the container
                    child: Text(
                      'Mentors',
                      style: TextStyle(
                        color: instructorsTextColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    'Results for ',
                    style: TextStyle(
                      color: Color(0xff202244),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '\"${widget.category}\"',
                    style: TextStyle(
                      color: Color(0xff0961F5),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<TimelineCubit, TimelineState>(
                  builder: (context, state) {
                    if (state is TimelineLoaded) {
                      final filteredCourses = state.courses
                          .where((course) => course.title == widget.category)
                          .toList();

                      // Use a set to ensure unique instructors based on name
                      final uniqueInstructorNames = <String>{};
                      final uniqueInstructors = <Map<String, String>>[];

                      for (var course in filteredCourses) {
                        if (uniqueInstructorNames.add(course.instructor)) {
                          uniqueInstructors.add({
                            'instructor': course.instructor,
                            'instructorImage': course.instructorImage,
                            'name': course.title,
                          });
                        }
                      }

                      return TabBarView(
                        controller: _tabController,
                        children: [
                          ListView.separated(
                            itemCount: filteredCourses.length,
                            itemBuilder: (BuildContext context, int index) {
                              final course = filteredCourses[index];
                              return CourseWidget(course: course);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                          ),
                          ListView.separated(
                            itemCount: uniqueInstructors.length,
                            itemBuilder: (BuildContext context, int index) {
                              final instructor = uniqueInstructors[index];
                              return GestureDetector(
                                onTap: () {},
                                child: Card(
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              instructor['instructorImage']!),
                                    ),
                                    title: Text(
                                      instructor['instructor']!,
                                      style: TextStyle(
                                        color: Color(0xff202244),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                      ),
                                    ),
                                    subtitle: Text(
                                      instructor['name']!,
                                      style: TextStyle(
                                        color: Color(0xff545454),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                height: 10,
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourseWidget extends StatelessWidget {
  const CourseWidget({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailsPage(course: course),
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
                    image: CachedNetworkImageProvider(course.image),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      course.isSold == false
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
                  course.isSold == false
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
  }
}
