class Post {
  late String id;
  late String title;
  late String description;
  late String location;
  late String type;
  late String text;
  late String image;
  late String video;
  late int likes;
  late String postedBy;
  late String community;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.text,
    required this.image,
    required this.video,
    required this.likes,
    required this.postedBy,
    required this.community,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? "",
      title: json['title']  ?? "",
      description: json['description']  ?? "",
      location: json['location'] ?? "",
      type: json['type'] ?? "",
      text: json['text'] ?? "",
      image: json['image'] ?? "",
      video: json['video'] ?? "",
      likes: json['likes'] ?? "",
      postedBy: json['postedBy'] ?? "",
      community: json['community'] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'description': description,
    'location': location,
    'type': type,
    'text': text,
    'image': image,
    'video': video,
    'likes': likes,
    'postedBy': postedBy,
    'community': community,
  };
}