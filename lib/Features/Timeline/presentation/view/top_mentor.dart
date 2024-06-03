import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__cubit.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopMentor extends StatefulWidget {
  const TopMentor({super.key});

  @override
  State<TopMentor> createState() => _TopMentorState();
}

class _TopMentorState extends State<TopMentor> {
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
          'Top Mentors',
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
              final Set<String> displayedMentors = {};
              final List<Widget> mentorWidgets = [];

              for (var course in state.courses) {
                if (!displayedMentors.contains(course.instructor)) {
                  displayedMentors.add(course.instructor);
                  mentorWidgets.add(
                    Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: CachedNetworkImageProvider(
                              course.instructorImage),
                        ),
                        title: Text(
                          course.instructor,
                          style: TextStyle(
                            color: Color(0xff202244),
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                        subtitle: Text(
                          course.title,
                          style: TextStyle(
                            color: Color(0xff545454),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: mentorWidgets),
              );
            }
            return Center(
              child: const CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
