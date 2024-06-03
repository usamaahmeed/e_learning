class CourseVideo {
  List<Map<String, dynamic>> videos;

  CourseVideo({
    required this.videos,
  });

  // Factory constructor to create a CourseVideo from a JSON object
  factory CourseVideo.fromJson(Map<String, dynamic> json) {
    return CourseVideo(
      videos: List<Map<String, dynamic>>.from(json['listOfVideos'] ?? []),
    );
  }

  // Method to convert a CourseVideo object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'listOfVideos': videos,
    };
  }
}
