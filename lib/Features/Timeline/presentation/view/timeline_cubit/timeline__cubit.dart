import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__state.dart';
import 'package:e_learning/core/utils/courses_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit() : super(TimelineInitial());

  void loadInitialData() async {
    try {
      emit(TimelineLoading());

      final theCourse =
          await FirebaseFirestore.instance.collection('courses').get();

      List<Course> listOfCourses = [];
      for (final courseDoc in theCourse.docs) {
        final data = courseDoc.data();
        if (data != null) {
          final modelCourse = Course.fromJson(data);
          listOfCourses.add(modelCourse);
        }
      }

      User? user = FirebaseAuth.instance.currentUser;
      List<String> bookCourses = [];

      if (user != null) {
        String userId = user.uid;
        DocumentReference userDoc =
            FirebaseFirestore.instance.collection('users').doc(userId);
        DocumentSnapshot userSnapshot = await userDoc.get();

        if (userSnapshot.exists) {
          List<dynamic> bookmarkedCourses =
              userSnapshot.get('bookmarkedCourses') ?? [];
          if (bookmarkedCourses != null) {
            bookCourses = List<String>.from(bookmarkedCourses);
          }
        }
      }

      // Shuffle the list of courses
      listOfCourses.shuffle();

      emit(TimelineLoaded(
        courses: listOfCourses,
        filteredCourses: listOfCourses,
        soldFilteredCourses:
            listOfCourses.where((course) => course.isSold).toList(),
        bookFilteredCourses: listOfCourses
            .where((course) => bookCourses.contains(course.courseId))
            .toList(),
        selectedCategory: "All",
        bookCourses: bookCourses,
      ));
    } catch (e) {
      emit(TimelineError("Failed to load courses: ${e.toString()}"));
    }
  }

  Future<void> initializeBookmarkState() async {}
//remove title if no course
  void removeCourseTitle(String id) {
    final state = this.state;
    if (state is TimelineLoaded) {
      final updatedCourses = List<Course>.from(state.courses);
      updatedCourses.removeWhere((element) => element.courseId == id);
      emit(TimelineLoaded(
        courses: updatedCourses,
        filteredCourses: state.filteredCourses,
        soldFilteredCourses: state.soldFilteredCourses,
        selectedCategory: state.selectedCategory,
        bookFilteredCourses: state.bookFilteredCourses,
        bookCourses: state.bookCourses,
      ));
    }
  }

  void removeCourse(Course course) {
    final state = this.state;
    if (state is TimelineLoaded) {
      final updatedBookFilteredCourses =
          List<Course>.from(state.bookFilteredCourses);
      updatedBookFilteredCourses.removeWhere((element) => element == course);

      emit(TimelineLoaded(
        courses: state.courses,
        filteredCourses: state.filteredCourses,
        soldFilteredCourses: state.soldFilteredCourses,
        selectedCategory: state.selectedCategory,
        bookFilteredCourses: updatedBookFilteredCourses,
        bookCourses: state.bookCourses,
      ));
    }
  }

  void filterCourses(String category) {
    final state = this.state;
    if (state is TimelineLoaded) {
      List<Course> filteredCourses;
      List<Course> soldFilteredCourses;
      List<Course> bookFilteredCourses;

      if (category == "All") {
        filteredCourses = state.courses;

        soldFilteredCourses =
            state.courses.where((course) => course.isSold).toList();
        bookFilteredCourses = state.courses
            .where((course) => state.bookCourses.contains(course.courseId))
            .toList();
      } else {
        filteredCourses =
            state.courses.where((course) => course.title == category).toList();
        soldFilteredCourses =
            filteredCourses.where((course) => course.isSold).toList();
        bookFilteredCourses = state.courses
            .where((course) =>
                course.title == category &&
                state.bookCourses.contains(course.courseId))
            .toList();
      }

      emit(TimelineLoaded(
        courses: state.courses,
        filteredCourses: filteredCourses,
        soldFilteredCourses: soldFilteredCourses,
        selectedCategory: category,
        bookFilteredCourses: bookFilteredCourses,
        bookCourses: state.bookCourses,
      ));
    }
  }
}
