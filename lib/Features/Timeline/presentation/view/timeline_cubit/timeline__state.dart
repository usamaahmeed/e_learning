import 'package:e_learning/core/utils/courses_model.dart';

abstract class TimelineState {}

class TimelineInitial extends TimelineState {}

class TimelineLoaded extends TimelineState {
  final List<Course> courses;
  final List<Course> filteredCourses;
  final String selectedCategory;

  TimelineLoaded({
    required this.courses,
    required this.filteredCourses,
    required this.selectedCategory,
  });
}
