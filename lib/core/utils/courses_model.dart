class Course {
  int id;
  String title;
  String name;
  double price;
  String image;
  double rate;
  String aboutCourse;
  String instructor;
  int hours;
  int videos;
  List<String> reviews;
  String instructorImage;
  int instructorCoursesCount;
  int studentsFollowingCount;
  double instructorRating;

  Course({
    required this.id,
    required this.title,
    required this.name,
    required this.price,
    required this.image,
    required this.rate,
    required this.aboutCourse,
    required this.instructor,
    required this.hours,
    required this.videos,
    required this.reviews,
    required this.instructorImage,
    required this.instructorCoursesCount,
    required this.studentsFollowingCount,
    required this.instructorRating,
  });

  // Factory constructor to create a Course from a JSON object
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      rate: json['rate'],
      aboutCourse: json['aboutCourse'],
      instructor: json['instructor'],
      hours: json['hours'],
      videos: json['videos'],
      reviews: List<String>.from(json['reviews']),
      instructorImage: json['instructorImage'],
      instructorCoursesCount: json['instructorCoursesCount'],
      studentsFollowingCount: json['studentsFollowingCount'],
      instructorRating: json['instructorRating'],
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
      'hours': hours,
      'videos': videos,
      'reviews': reviews,
      'instructorImage': instructorImage,
      'instructorCoursesCount': instructorCoursesCount,
      'studentsFollowingCount': studentsFollowingCount,
      'instructorRating': instructorRating,
    };
  }
}
