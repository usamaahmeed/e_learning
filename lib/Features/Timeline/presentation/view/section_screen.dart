import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/Timeline/presentation/view/videoPlayer.dart';
import 'package:e_learning/core/utils/coursesVideo_model.dart';
import 'package:e_learning/core/utils/courses_model.dart';
import 'package:flutter/material.dart';

class SectionScreen extends StatelessWidget {
  final Course course;

  const SectionScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('courses')
          .doc(course.courseId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Color(0xffF5F9FF),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            body: Center(child: Text('Course not found')),
          );
        } else {
          final courseData = snapshot.data!.data();
          final courseVideo = CourseVideo.fromJson(courseData ?? {});

          return _buildCourseScreen(context, course, courseVideo);
        }
      },
    );
  }

  Widget _buildCourseScreen(
      BuildContext context, Course course, CourseVideo courseVideo) {
    return Scaffold(
      backgroundColor: Color(0xffF5F9FF),
      appBar: AppBar(
        backgroundColor: Color(0xffF5F9FF),
        title: course.isSold == true
            ? Text(
                'My Courses',
                style: TextStyle(
                  color: Color(0xff202244),
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                ),
              )
            : Text(
                'Curriculcum',
                style: TextStyle(
                  color: Color(0xff202244),
                  fontWeight: FontWeight.w600,
                  fontSize: 21,
                ),
              ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider();
                        },
                        itemBuilder: (BuildContext context, int index) {
                          var video = courseVideo.videos[index];
                          return Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xffE8F1FF),
                                  radius: 32,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffF5F9FF),
                                    radius: 30,
                                    child: Text(
                                      '0${index + 1}',
                                      style: TextStyle(
                                        color: Color(0xff202244),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 180,
                                  child: Text(
                                    video['name'] ?? '',
                                    style: TextStyle(
                                      color: Color(0xff202244),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                course.isSold == true || index == 0
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoPlayerScreen(
                                                videoUrl:
                                                    video['videoUrl'] ?? '',
                                                name: video['name'] ?? '',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          size: 35,
                                          Icons.play_circle_fill_outlined,
                                          color: Color(0xff0961F5),
                                        ),
                                      )
                                    : Icon(
                                        Icons.lock_outline,
                                        color: Color(0xff202244),
                                      ),
                              ],
                            ),
                          );
                        },
                        itemCount: courseVideo.videos.length,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                course.isSold == false
                    ? ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Enroll Course ${course.price} E£',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 60),
                          backgroundColor: Color(0xff0961F5),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          course.isSold == true
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 120,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 60,
                            width: 94,
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Color(0xffB4BDC4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            child: Container(
                              height: 60,
                              width: 94,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Color(0xffE8F1FF),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text("Start Course Again"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30))),
                            fixedSize: Size(240, 60),
                            backgroundColor: Color(0xff0961F5),
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
