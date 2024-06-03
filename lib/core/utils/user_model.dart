class UserModel {
  String email;

  UserModel({
    required this.email,
  });

  // Factory constructor to create a Course from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
    );
  }

  // Method to convert a Course object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
