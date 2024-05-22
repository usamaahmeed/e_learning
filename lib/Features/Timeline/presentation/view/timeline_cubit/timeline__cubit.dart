import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__state.dart';
import 'package:e_learning/core/utils/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit() : super(TimelineInitial());

  void loadInitialData() {
    emit(TimelineLoaded(
        courses: coursesList,
        filteredCourses: coursesList,
        selectedCategory: "All"));
  }

  void filterCourses(String category) {
    if (category == "All") {
      emit(TimelineLoaded(
          courses: coursesList,
          filteredCourses: coursesList,
          selectedCategory: category));
    } else {
      final filteredCourses =
          coursesList.where((course) => course.title == category).toList();
      emit(TimelineLoaded(
          courses: coursesList,
          filteredCourses: filteredCourses,
          selectedCategory: category));
    }
  }
}
