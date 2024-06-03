class Course {
  int id;
  String title;
  String name;
  double price;
  String image;
  double rate;
  String aboutCourse;
  String instructor;
  String courseId;
  int hours;
  int videos;
  List<String> reviews;

  String instructorImage;
  int instructorCoursesCount;
  int studentsFollowingCount;
  double instructorRating;
  bool isBooked; // Indicates whether the user is registered for this course
  bool isSold; // Indicates whether the course is sold

  Course({
    required this.id,
    required this.title,
    required this.name,
    required this.price,
    required this.image,
    required this.rate,
    required this.aboutCourse,
    required this.instructor,
    required this.courseId,
    required this.hours,
    required this.videos,
    required this.reviews,
    required this.instructorImage,
    required this.instructorCoursesCount,
    required this.studentsFollowingCount,
    required this.instructorRating,
    required this.isBooked,
    required this.isSold,
  });

  // Factory constructor to create a Course from a JSON object
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      name: json['name'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      rate: json['rate']?.toDouble() ?? 0.0,
      aboutCourse: json['aboutCourse'] ?? '',
      instructor: json['instructor'] ?? '',
      courseId: json['courseId'] ?? '',
      hours: json['hours'] ?? 0,
      videos: json['videos'] ?? 0,
      reviews:
          (json['reviews'] != null) ? List<String>.from(json['reviews']) : [],
      instructorImage: json['instructorImage'] ?? '',
      instructorCoursesCount: json['instructorCoursesCount'] ?? 0,
      studentsFollowingCount: json['studentsFollowingCount'] ?? 0,
      instructorRating: json['instructorRating']?.toDouble() ?? 0.0,
      isBooked: json['isBooked'] ?? false,
      isSold: json['isSold'] ?? false,
    );
  }

  // Method to convert a Course object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': name,
      'price': price,
      'image': image,
      'rate': rate,
      'aboutCourse': aboutCourse,
      'instructor': instructor,
      'courseId': courseId,
      'hours': hours,
      'videos': videos,
      'reviews': reviews,
      'instructorImage': instructorImage,
      'instructorCoursesCount': instructorCoursesCount,
      'studentsFollowingCount': studentsFollowingCount,
      'instructorRating': instructorRating,
      'isBooked': isBooked,
      'isSold': isSold,
    };
  }
}
