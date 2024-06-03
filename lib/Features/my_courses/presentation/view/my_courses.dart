import 'package:e_learning/Features/Timeline/presentation/view/filterScreen.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__cubit.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyCourses extends StatefulWidget {
  const MyCourses({super.key});

  @override
  State<MyCourses> createState() => _PopularCoursesState();
}

class _PopularCoursesState extends State<MyCourses> {
  @override
  void initState() {
    super.initState();
    context.read<TimelineCubit>().loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimelineCubit, TimelineState>(
      builder: (context, state) {
        if (state is TimelineLoaded) {
          //filter courses by by courese .isSold
          final courses =
              state.courses.where((element) => element.isSold == true).toList();
          final categories =
              ["All"] + courses.map((course) => course.title).toSet().toList();

          return Column(
            children: [
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
                  itemCount: state.soldFilteredCourses.length,
                  itemBuilder: (BuildContext context, int index) {
                    final course = state.soldFilteredCourses[index];

                    return CourseWidget(
                      course: course,
                    );
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
    );
  }
}
