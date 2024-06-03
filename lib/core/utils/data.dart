import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_learning/core/utils/courses_model.dart';

List<String> images2 = [
  'assets/images/slider/image1.png',
  'assets/images/slider/image2.png',
  'assets/images/slider/image7.png',
  'assets/images/slider/image5.png',
  'assets/images/slider/image6.png',
  'assets/images/slider/slider1.png',
];

List<String> reviews = [
  'assets/images/reviews/instractor12.png',
  'assets/images/reviews/instractor13.png',
  'assets/images/reviews/man1.png',
  'assets/images/reviews/man2.png',
  'assets/images/reviews/man3.png',
  'assets/images/reviews/man5.png',
  'assets/images/reviews/man6.png',
];
List<String> category = [
  '3D Design',
  'Flutter',
  'Graphic Design',
  'Java',
  'Web Development',
];
List<String> category1 = [
  'All',
  'Flutter',
  'Web Development',
  'Java',
  '3D Design',
  'Graphic Design',
];

final List<Course> coursesList = [
  Course(
    id: 2,
    title: 'Flutter',
    name: 'The Complete Flutter Development Bootcamp with Dart',
    price: 499,
    image: 'assets/images/courses/flutter.png',
    rate: 4.9,
    aboutCourse:
        'Welcome to the Complete Flutter App Development Bootcamp with Dart - created in collaboration with the Google Flutter team.Now includes a brand new module on Flutter State Management!Covering all the fundamental concepts for Flutter development, this is the most comprehensive Flutter course available online.We built this course over months, perfecting the curriculum together with the Flutter team to teach you Flutter from scratch and make you into  a skilled Flutter developer with a strong portfolio of beautiful Flutter apps.Our complete Flutter development bootcamp teaches you how to code using Dart and build beautiful, fast, native-quality iOS and Android apps. Even if you have ZERO programming experience.I\'ll take you step-by-step through engaging and fun video tutorials and teach you everything you need to know to succeed as a Flutter developer.The course includes 28+ hours of HD video tutorials and builds your programming knowledge while making real world apps. e.g. Whatsapp, QuizUp and Yahoo Weather.By the end of this course, you will be fluently programming in Dart and be ready to build your own Flutter apps and become a fully fledged Flutter developer.You\'ll also have a portfolio of over 15 apps that you can show off to any potential employer.',
    instructor: 'Youssef Guba',
    hours: 6,
    videos: 8,
    reviews: [
      'READ CAREFULLY! m... NOT a MARKETER but a normal person on udemy taking a course!A 4 Year Old Course! Many had written in comments about the outdated course!It may be the outdated course! But Especially me who was a fresher in MOBILE DEV field(Experienced in WEB DEV) fells that this is the BEST COURSE to prepare for the BASE of FLUTTER.FLUTTER TEAM has updated FLUTTER CONCEPTS more frequently in last 4 years but this course will TEACH you in SUCH a WAY that is MUST to LEARN before moving to LATEST Concepts.Its like you can\'t learn reading without knowing the abcd...z letters.GOING through each video 4-5 times makes you understand deeply and it really CREATES your BASE Knowledge of FLUTTER Strong.I would really say that you will be confident to make a career in flutter!'
          'his explanations and directions were easy to understand',
      'It was an amazing experience! The flexibility, interactive content, and supportive community made learning [subject/course name] both enjoyable and rewarding. Highly recommend giving it a try!',
    ],
    instructorImage: 'assets/images/insrtactor/instractor10.png',
    instructorCoursesCount: 2,
    studentsFollowingCount: 951,
    instructorRating: 1546,
    courseId: '',
    isBooked: false,
    isSold: false,
  ),
];
// add courseList to firebase collecion courses

Future<void> addCourses() async {
  final CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');
  coursesList.forEach((course) async {
    await courses.add(course.toJson());
  });
}
