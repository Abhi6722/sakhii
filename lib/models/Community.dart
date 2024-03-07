import 'package:sakhii/models/Post.dart';

class Community {
  late String id;
  late String name;
  late String description;
  late String category;
  late String location;
  late String createdBy;
  late List<String> memberIds;
  late List<Post> posts;

  Community({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.location,
    required this.createdBy,
    required this.memberIds,
    required this.posts,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      location: json['location'],
      createdBy: json['createdBy'],
      memberIds: List<String>.from(json['members']),
      posts: (json['posts'] as List<dynamic>).map((post) => Post.fromJson(post)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'description': description,
    'category': category,
    'location': location,
    'createdBy': createdBy,
    'members': memberIds,
    'posts': posts,
  };
}