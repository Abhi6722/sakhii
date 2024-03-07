class User {
  String id;
  String email;
  String name;
  String gender;
  String mobile;
  String image;
  int age;
  String address;
  final List<String> pendingRequests;
  final List<String> friends;
  final List<String> blockedUsers;
  final List<String> sosUsers;
  String fcmToken;
  String safeOtp;
  Location location;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.gender,
    required this.image,
    required this.mobile,
    required this.age,
    required this.address,
    required this.pendingRequests,
    required this.friends,
    required this.blockedUsers,
    required this.sosUsers,
    required this.fcmToken,
    required this.safeOtp,
    required this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      mobile: json['mobile'] ?? '',
      age: json['age'] ?? 0,
      address: json['address'] ?? '',
      pendingRequests: List<String>.from(json['pendingRequests']),
      friends: List<String>.from(json['friends']),
      blockedUsers: List<String>.from(json['blockedUsers']),
      sosUsers: List<String>.from(json['sosUsers']),
      fcmToken: json['fcmToken'] ?? '',
      safeOtp: json['safeOtp'] ?? '',
      location: Location.fromJson(json['location'] ?? {}),
    );
  }
}

class Location {
  String liveLink;
  String longitude;
  String latitude;

  Location({
    required this.liveLink,
    required this.longitude,
    required this.latitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      liveLink: json['liveLink'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
    );
  }
}