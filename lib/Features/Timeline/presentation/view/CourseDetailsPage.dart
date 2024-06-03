import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/Features/Timeline/presentation/view/section_screen.dart';
import 'package:e_learning/Features/Timeline/presentation/view/videoPlayer.dart';
import 'package:e_learning/core/utils/coursesVideo_model.dart';
import 'package:e_learning/core/utils/courses_model.dart';
import 'package:e_learning/core/utils/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseDetailsPage extends StatefulWidget {
  final Course course;

  CourseDetailsPage({required this.course});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _currentTabIndex =
          _tabController.index; // تحديث المتغير بفهرس التبويب الحالي
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final reviewsImages = reviews;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F9FF),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 300.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: CachedNetworkImage(
                      imageUrl: widget.course.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Container(
                          width: 360,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x14000000),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: SizedBox()),
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Color(0xff167F71),
                                          child: Icon(
                                            Icons.video_library_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.course.title,
                                          style: TextStyle(
                                            color: Color(0xFFFF6B00),
                                            fontSize: 12,
                                            fontFamily: 'Mulish',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Color(0xffFAC025),
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: .5,
                                            ),
                                            Text(
                                              widget.course.rate.toString(),
                                              style: TextStyle(
                                                color: Color(0xFF202244),
                                                fontSize: 11,
                                                fontFamily: 'Mulish',
                                                fontWeight: FontWeight.w800,
                                                height: 0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      widget.course.name,
                                      style: TextStyle(
                                        color: Color(0xFF202244),
                                        fontSize: 20,
                                        fontFamily: 'Jost',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.video_camera_back_outlined,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          '21 Class',
                                          style: TextStyle(
                                            color: Color(0xFF202244),
                                            fontSize: 11,
                                            fontFamily: 'Mulish',
                                            fontWeight: FontWeight.w800,
                                            height: 0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          '|',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontFamily: 'Mulish',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Icon(
                                          Icons.watch_later_outlined,
                                          size: 18,
                                          color: Color(0xff111224),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        Text(
                                          widget.course.hours.toString() +
                                              ' Hours',
                                          style: TextStyle(
                                            color: Color(0xFF202244),
                                            fontSize: 11,
                                            fontFamily: 'Mulish',
                                            fontWeight: FontWeight.w800,
                                            height: 0,
                                          ),
                                        ),
                                        Expanded(
                                          child: SizedBox(),
                                        ),
                                        Text(
                                          widget.course.price.toString() +
                                              ' E£',
                                          style: TextStyle(
                                            color: Color(0xFF0961F5),
                                            fontSize: 21,
                                            fontFamily: 'Mulish',
                                            fontWeight: FontWeight.w800,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                            ],
                          ),
                        ),
                        TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(),
                          dividerColor: Color(0xFFF5F9FF),
                          tabs: [
                            Tab(
                              child: Container(
                                constraints:
                                    BoxConstraints.expand(), // Full width
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'About',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                constraints:
                                    BoxConstraints.expand(), // Full width
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text(
                                    'Curriculum',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: _currentTabIndex == 0
                              ? MediaQuery.sizeOf(context).height
                              : 320,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              TabWidgetNum1(
                                  widget: widget, reviewsImages: reviewsImages),
                              TabWidgetNum2(
                                course: widget.course,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: widget.course.isSold == false
                      ? ElevatedButton(
                          onPressed: () {
                            //push to MyDemoPage

                            // Navigator.of(context).pushReplacement(
                            //   MaterialPageRoute(
                            //     builder: (context) => MyDemoPage(
                            //       course: widget.course,
                            //     ),
                            //   ),
                            // );
                          },
                          child: Text(
                            'Enroll Course ${widget.course.price} E£',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff0961F5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              fixedSize:
                                  Size(MediaQuery.of(context).size.width, 60)),
                        )
                      : SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabWidgetNum1 extends StatelessWidget {
  const TabWidgetNum1({
    super.key,
    required this.widget,
    required this.reviewsImages,
  });

  final CourseDetailsPage widget;
  final List<String> reviewsImages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  width: 360,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Text(
                    widget.course.aboutCourse,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFFA0A4AB),
                      fontSize: 13,
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Instructor',
                  style: TextStyle(
                    color: Color(0xFF202244),
                    fontSize: 18,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.course.instructorImage),
                          fit: BoxFit.fill,
                        ),
                        shape: OvalBorder(),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.course.instructor,
                          style: TextStyle(
                            color: Color(0xFF202244),
                            fontSize: 17,
                            fontFamily: 'Jost',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          widget.course.title,
                          style: TextStyle(
                            color: Color(0xFF545454),
                            fontSize: 13,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                        child: SizedBox(
                      height: 10,
                    )),
                    Icon(
                      Icons.chat,
                      color: Colors.grey,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'What You’ll Get',
                  style: TextStyle(
                    color: Color(0xFF202244),
                    fontSize: 18,
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.book_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '25 Lessons',
                      style: TextStyle(
                        color: Color(0xff545454),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.phone_iphone_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Access Mobile, Desktop & TV',
                      style: TextStyle(
                        color: Color(0xff545454),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(CupertinoIcons.chart_bar),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Beginner Level',
                      style: TextStyle(
                        color: Color(0xff545454),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.multitrack_audio_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Audio Book',
                      style: TextStyle(
                        color: Color(0xff545454),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.accessible_forward_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Lifetime Access',
                      style: TextStyle(
                        color: Color(0xff545454),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.quiz_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '100 Quizzes',
                      style: TextStyle(
                        color: Color(0xff545454),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.celebration_outlined),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Certificate of Completion',
                      style: TextStyle(
                        color: Color(0xff545454),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reviews',
                      style: TextStyle(
                        color: Color(0xFF202244),
                        fontSize: 18,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'See All',
                          style: TextStyle(
                            color: Color(0xff0961F5),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Color(0xff0961F5),
                          size: 18,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Color(0xFFF4F8FE),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage(reviewsImages[index]),
                        ),
                        title: Text(
                          widget.course.reviews[index],
                          style: TextStyle(
                            color: Color(0xFF545454),
                            fontSize: 12,
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                        ),
                        //rate
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Color(0xffFAC025),
                              size: 15,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              widget.course.rate.toString(),
                              style: TextStyle(
                                color: Color(0xFF202244),
                                fontSize: 11,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w800,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: widget.course.reviews.length,
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TabWidgetNum2 extends StatefulWidget {
  final Course course;
  const TabWidgetNum2({
    super.key,
    required this.course,
  });

  @override
  State<TabWidgetNum2> createState() => _TabWidgetNum2State();
}

class _TabWidgetNum2State extends State<TabWidgetNum2> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _courseFuture;

  @override
  void initState() {
    super.initState();
    // Fetch the course document based on courseId
    _courseFuture = FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.course.courseId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _courseFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('Course not found'));
        } else {
          // Parse the course document into a CourseVideo object
          final courseData = snapshot.data!.data();
          final courseVideo = CourseVideo.fromJson(courseData ?? {});

          return Column(
            children: [
              Expanded(
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
                        var video =
                            courseVideo.videos[index] as Map<String, dynamic>;
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
                                  maxLines: 1,
                                  video['name'],
                                  style: TextStyle(
                                    color: Color(0xff202244),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              widget.course.isSold == true || index == 0
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerScreen(
                                              videoUrl: video['videoUrl'] ?? '',
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
                      itemCount: courseVideo.videos.length > 2
                          ? 2
                          : courseVideo.videos.length,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'More Lessons',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff202244),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SectionScreen(
                                  course: widget.course,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'See All',
                                style: TextStyle(
                                  color: Color(0xff0961F5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Color(0xff0961F5),
                                size: 18,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
