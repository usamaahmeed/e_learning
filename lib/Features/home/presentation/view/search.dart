import 'package:e_learning/Features/home/presentation/view/courses.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:e_learning/core/utils/courses_model.dart';
import 'package:e_learning/core/utils/data.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Course> searchResults = [];
  TextEditingController searchController = TextEditingController();

  void searchCourses(String query) {
    final results = coursesList.where((course) {
      final courseTitle = course.title.toLowerCase();
      final courseName = course.name.toLowerCase();
      final searchLower = query.toLowerCase();

      return courseTitle.contains(searchLower) ||
          courseName.contains(searchLower);
    }).toList();

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F9FF),
      appBar: AppBar(
        backgroundColor: Color(0xffF5F9FF),
        title: Text(
          'Search',
          style: TextStyle(
            color: Color(0xff202244),
            fontWeight: FontWeight.w600,
            fontSize: 21,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search_outlined),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    searchCourses('');
                  },
                ),
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
              onChanged: searchCourses,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final course = searchResults[index];
                  return ListTile(
                    title: Text(course.name),
                    subtitle: Text(course.title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailsPage(course: course),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
