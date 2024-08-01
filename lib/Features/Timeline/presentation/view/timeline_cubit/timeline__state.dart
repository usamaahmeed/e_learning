import 'package:e_learning/core/utils/courses_model.dart';

abstract class TimelineState {}

class TimelineInitial extends TimelineState {}

class TimelineLoading extends TimelineState {}

class TimelineLoaded extends TimelineState {
  final List<Course> courses;
  final List<Course> filteredCourses;
  final List<Course> soldFilteredCourses;
  final List<Course> bookFilteredCourses;
  final List<String> bookCourses;
  final List<String> soldCourses;
  final String selectedCategory;

  TimelineLoaded({
    required this.courses,
    required this.filteredCourses,
    required this.bookCourses,
    required this.soldCourses,
    required this.soldFilteredCourses,
    required this.bookFilteredCourses,
    required this.selectedCategory,
  });
}

class TimelineError extends TimelineState {
  final String message;

  TimelineError(this.message);
}
