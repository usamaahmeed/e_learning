import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/Timeline/presentation/view/CourseDetailsPage.dart';
import 'package:e_learning/core/utils/courses_model.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Course> searchResults = [];
  List<Course> allCourses = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('courses').get();
    List<Course> courses = snapshot.docs.map((doc) {
      return Course.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();

    setState(() {
      allCourses = courses;
    });
  }

  void searchCourses(String query) {
    final lowerCaseQuery = query.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    final results = allCourses.where((course) {
      final courseTitle = course.title.toLowerCase();
      final courseName = course.name.toLowerCase();

      return courseTitle.contains(lowerCaseQuery) ||
          courseName.contains(lowerCaseQuery);
    }).toList();

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                      borderSide:
                          BorderSide(width: 0.0, color: Color(0xffE8F1FF)),
                      borderRadius: BorderRadius.circular(20)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff0961F5)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: searchCourses,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: searchResults.isEmpty && searchController.text.isEmpty
                    ? Center(
                        child: Text(
                          'Start typing to search for courses',
                          style: TextStyle(
                            color: Color(0xff505050),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : searchResults.isEmpty
                        ? Center(
                            child: Text(
                              'No Results',
                              style: TextStyle(
                                color: Color(0xff505050),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final course = searchResults[index];
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
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 1,
                                        offset: Offset(1, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      course.name,
                                      style: TextStyle(
                                        color: Color(0xff202244),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    subtitle: Text(
                                      course.title,
                                      style: TextStyle(
                                        color: Color(0xff545454),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Color(0xff0961F5),
                                    ),
                                  ),
                                ),
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
