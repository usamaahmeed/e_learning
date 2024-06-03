import 'package:e_learning/Features/Timeline/presentation/view/filterScreen.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__cubit.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularCourses extends StatefulWidget {
  const PopularCourses({super.key});

  @override
  State<PopularCourses> createState() => _PopularCoursesState();
}

class _PopularCoursesState extends State<PopularCourses> {
  @override
  void initState() {
    super.initState();
    context.read<TimelineCubit>().loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F9FF),
        title: Text(
          'Popular Courses',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: Color(0xff202244),
          ),
        ),
        elevation: 0,
        surfaceTintColor: Color(0xFFF5F9FF),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder<TimelineCubit, TimelineState>(
          builder: (context, state) {
            if (state is TimelineLoaded) {
              final categories = ["All"] +
                  state.courses.map((course) => course.title).toSet().toList();

              return Column(
                children: [
                  const SizedBox(height: 15),
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
                      itemCount: state.filteredCourses.length,
                      itemBuilder: (BuildContext context, int index) {
                        final course = state.filteredCourses[index];

                        return CourseWidget(course: course);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: 10,
                        );
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
        ),
      ),
    );
  }
}
