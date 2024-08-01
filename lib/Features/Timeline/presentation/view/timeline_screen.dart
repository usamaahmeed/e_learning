import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_learning/Features/Timeline/presentation/view/CourseDetailsPage.dart';
import 'package:e_learning/Features/Timeline/presentation/view/categories_screen.dart';
import 'package:e_learning/Features/Timeline/presentation/view/filterScreen.dart';
import 'package:e_learning/Features/Timeline/presentation/view/popular_courses.dart';
import 'package:e_learning/Features/Timeline/presentation/view/search.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__cubit.dart';
import 'package:e_learning/Features/Timeline/presentation/view/timeline_cubit/timeline__state.dart';
import 'package:e_learning/Features/Timeline/presentation/view/top_mentor.dart';
import 'package:e_learning/Features/Timeline/presentation/view/widget/book_widget.dart';
import 'package:e_learning/Features/Timeline/presentation/view/widget/slider_widget.dart';
import 'package:e_learning/core/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimelineCubit()..loadInitialData(),
      child: TimelineView(),
    );
  }
}

class TimelineView extends StatelessWidget {
  const TimelineView({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: RefreshIndicator(
        backgroundColor: Color(0xFFF5F9FF),
        onRefresh: () async {
          context.read<TimelineCubit>().loadInitialData();
        },
        child: BlocBuilder<TimelineCubit, TimelineState>(
          builder: (context, state) {
            if (state is TimelineLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi ${user!.displayName}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff202244),
                                ),
                              ),
                              Container(
                                width: 244,
                                child: Text(
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  'What Would you like to learn Today? Search Below.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff545454),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DetailPage(),
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'hero-tag',
                              key: ValueKey('hero-tag'),
                              child: CircleAvatar(
                                backgroundColor: Color(0xffE8F1FF),
                                radius: 25,
                                backgroundImage: user.photoURL != null
                                    ? CachedNetworkImageProvider(
                                        user.photoURL!,
                                      )
                                    : AssetImage('assets/images/avatar.png'),
                              ),
                            ),
                            // child: CircleAvatar(
                            //   radius: 25,
                            //   backgroundColor: Color(0xffE8F1FF),
                            //   backgroundImage: user.photoURL != null
                            //       ? CachedNetworkImageProvider(
                            //           user.photoURL!,
                            //         )
                            //       : AssetImage('assets/images/avatar.png'),
                            // ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 44),
                      TextFormField(
                        readOnly: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.search_outlined),
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
                                  width: 0.0,
                                  color: ColorsData.backgroundColor),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff0961F5)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      SliderWidget(),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff202244),
                            ),
                          ),
                          Expanded(child: SizedBox()),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllCoursesScreen(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  'See All',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff0961F5),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Color(0xff0961F5),
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      if (state is TimelineLoaded) ...[
                        SizedBox(
                          height: 35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: state.courses
                                  .map((course) => course.title)
                                  .toSet()
                                  .take(4)
                                  .map((category) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FilteredCoursesScreen(
                                          category: category,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xffE8F1FF),
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: Color(0xff202244),
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
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Text(
                              'Popular Courses',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff202244),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PopularCourses(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'See All',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff0961F5),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Color(0xff0961F5),
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Column(
                          children: [
                            SizedBox(
                              height: 35,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: ["All"]
                                      .followedBy(state.courses
                                          .map((course) => course.title)
                                          .toSet()
                                          .take(5))
                                      .map((category) {
                                    return GestureDetector(
                                      onTap: () {
                                        context
                                            .read<TimelineCubit>()
                                            .filterCourses(category);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color:
                                              state.selectedCategory == category
                                                  ? Color(0xff167F71)
                                                  : Color(0xffE8F1FF),
                                        ),
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            color: state.selectedCategory ==
                                                    category
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
                            SizedBox(
                              height: 240,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: state.filteredCourses.map((course) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CourseDetailsPage(
                                                    course: course),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 240,
                                        width: 280,
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Color(0xffE8F1FF),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              spreadRadius: 2,
                                              blurRadius: 1,
                                              offset: Offset(1, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 134,
                                              width: 280,
                                              child: CachedNetworkImage(
                                                imageUrl: course.image,
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            const CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) {
                                                  debugPrint(
                                                      '================$error================${course.image}');
                                                  return SizedBox();
                                                },
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 106,
                                              width: 280,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20),
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                ),
                                              ),
                                              padding: EdgeInsets.only(
                                                top: 10,
                                                left: 14,
                                                right: 19,
                                                bottom: 21,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        course.title,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xffFF6B00),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: SizedBox(),
                                                      ),

                                                      // icon bookmark stream update data in firebase

                                                      !state.soldCourses
                                                              .contains(course
                                                                  .courseId)
                                                          ? BookMarkWidget(
                                                              course: course)
                                                          : SizedBox(),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      course.name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff202244),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 120,
                                                    child: Row(
                                                      mainAxisAlignment: !state
                                                              .soldCourses
                                                              .contains(course
                                                                  .courseId)
                                                          ? MainAxisAlignment
                                                              .spaceBetween
                                                          : MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        !state.soldCourses
                                                                .contains(course
                                                                    .courseId)
                                                            ? Text(
                                                                '${course.price} E£',
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xff0961F5),
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        !state.soldCourses
                                                                .contains(course
                                                                    .courseId)
                                                            ? Text(
                                                                '|',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 15,
                                                                ),
                                                              )
                                                            : SizedBox(),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.star,
                                                              color: Color(
                                                                  0xffFAC025),
                                                            ),
                                                            Text(
                                                              course.rate
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xff202244),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Top Mentor',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff202244),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TopMentor(),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'See All',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff0961F5),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Color(0xff0961F5),
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: (state)
                                .courses
                                .map((course) => course.instructor)
                                .toSet()
                                .take(5)
                                .map((instructor) {
                              String instructorImage = state.courses
                                  .firstWhere((course) =>
                                      course.instructor == instructor)
                                  .instructorImage;
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.only(right: 18),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 80,
                                        child: CachedNetworkImage(
                                          imageUrl: instructorImage,
                                          placeholder: (context, url) => Center(
                                              child:
                                                  const CircularProgressIndicator()),
                                          errorWidget: (context, url, error) {
                                            debugPrint(
                                                '================$error================${instructorImage}');
                                            return SizedBox();
                                          },
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 80,
                                        child: Text(
                                          overflow: TextOverflow.ellipsis,
                                          instructor,
                                          style: TextStyle(
                                            color: Color(0xff202244),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ] else if (state is TimelineLoading) ...[
                        Center(child: CircularProgressIndicator())
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFFF5F9FF),
      appBar: AppBar(
        title: Text(
          '${user!.displayName}',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w600,
            color: Color(0xff202244),
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFFF5F9FF),
      ),
      body: Center(
        child: Hero(
          tag: 'hero-tag',
          key: ValueKey('hero-tag'),
          child: Image(
            image: user.photoURL != null
                ? CachedNetworkImageProvider(
                    user.photoURL!,
                  )
                : AssetImage('assets/images/avatar.png'),
          ),
        ),
      ),
    );
  }
}
